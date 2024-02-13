args@{ pkgs, config, ... }:
let email-utils = import ./email-utils.nix args;
in {
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";

  accounts.email.accounts.protonmail =
    let
      protonmail-bridge-pass = pkgs.writeShellScriptBin "protonmail-bridge-pass" ''
        ${pkgs.libsecret}/bin/secret-tool lookup protonmail-bridge password
      '';

      # Must be manually generated with
      # openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
      certificatesFile = "${config.xdg.dataHome}/certs/protonmail.crt";
    in
    rec {
      primary = true;
      flavor = "plain"; # protonmail, if needed

      realName = "Rafael Carvalho";
      address = "contact@rafaelrc.com";
      aliases = [
        "rafaelrc7@proton.me"
        "rafaelrc7@pm.me"
      ];

      signature = {
        showSignature = "append";
        text = ''
          att.
            Rafael Carvalho

            pgp key: https://pgp.rafaelrc.com
        '';
      };

      gpg = {
        key = "31DE9B4380A123E50CA4B834227EF83D7E920D08";
        encryptByDefault = true;
        signByDefault = true;
      };

      folders = {
        inbox = "Inbox";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
      };

      # protonmail-bridge settings
      userName = "contact@rafaelrc.com";
      passwordCommand = ''${protonmail-bridge-pass}/bin/protonmail-bridge-pass'';

      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
          inherit certificatesFile;
        };
      };

      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
          inherit certificatesFile;
        };
      };

      # Tools
      msmtp.enable = true;

      mbsync = {
        enable = true;
        create = "maildir";
      };

      imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        extraConfig = {
          wait = 5;
        };

        onNotify = ''${email-utils.sync-mail}/bin/sync-mail protonmail'';

        onNotifyPost = ''${email-utils.notify-new-mail}/bin/notify-new-mail protonmail'';
      };

      notmuch.enable = true;
    };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.imapnotify.enable = true;
  programs.notmuch.enable = true;
  programs.abook = {
    enable = true;
    extraConfig = ''
      set www_command=${pkgs.lynx}/bin/lynx
      set print_command=${pkgs.cups}/bin/lpr
      set use_ascii_only=false
      set use_colors=true
      set mutt_command=${pkgs.neomutt}/bin/neomutt
    '';
  };

  # Runs mbsync once after login
  systemd.user = {
    services.protonmail-mbsync = {
      Unit = {
        Description = "Sync emails on login";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${email-utils.sync-mail}/bin/sync-mail";
        ExecStartPost = "${email-utils.notify-new-mail}/bin/notify-new-mail";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}


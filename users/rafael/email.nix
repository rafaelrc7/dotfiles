{ pkgs, config, ... }: {
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";

  accounts.email.accounts.protonmail = let
    # Must be manually generated with
    # openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
    certificatesFile = "${config.xdg.dataHome}/certs/protonmail.crt";
  in rec {
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
      '';
    };

    gpg = {
      # TODO
      # key = "";
      # encryptByDefault = true;
      # signByDefault = true;
    };

    folders = {
      inbox = "Inbox";
      sent = "Sent";
      drafts = "Drafts";
      trash = "Trash";
    };

    # protonmail-bridge settings
    userName = "contact@rafaelrc.com";
    passwordCommand = ''pass show Personal/protonmail-bridge@`uname -n`'';

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

    neomutt = {
      enable = true;
      extraMailboxes = [ "Starred" "Archive" folders.sent folders.drafts folders.trash "Spam" ];
      extraConfig = ''
        set move = no
      '';
    };

    notmuch = {
      enable = true;
      neomutt = {
        enable = true;
      };
    };
  };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;

  # Mail Sync
  systemd.user = {
    services.mbsync = {
      Unit.Description = "Mailbox synchronization service";

      Service = {
        Type = "oneshot";
        ExecStart = "${config.programs.mbsync.package}/bin/mbsync -Va";
        ExecStartPost = "${pkgs.notmuch}/bin/notmuch new";
      };

      Install.WantedBy = [ "default.target" ];
    };

    timers.mbsync = {
      Unit.Description = "Mailbox synchronization service";

      Timer = {
        OnBootSec="1m";
        OnUnitActiveSec="3m";
        Unit="mbsync.service";
      };

      Install.WantedBy = [ "timers.target" ];
    };
  };

  # Protonmail-Bridge service
  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "Protonmail SMTP/IMAP client";
      Wants = "network-online.target";
      After = "network-online.target";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install.WantedBy = [ "default.target" ];
  };
}


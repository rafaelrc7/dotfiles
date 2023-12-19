{ pkgs, config, ... }: {
  accounts.email.maildirBasePath = "${config.xdg.dataHome}/maildir";

  accounts.email.accounts.protonmail = let
    protonmail-bridge-pass = pkgs.writeShellScriptBin "protonmail-bridge-pass" ''
      pass show Personal/protonmail-bridge@`uname -n`
    '';

    # https://unix.stackexchange.com/questions/231184/how-can-i-use-mutt-with-local-storage-imap-and-instant-pushing-of-new-email
    new-mail-counter = pkgs.writeShellScriptBin "new-mail-counter" ''
      mail_account="protonmail"

      account_maildir="${config.accounts.email.maildirBasePath}"/"$mail_account"

      mail_count_directory="${config.home.homeDirectory}/.cache/newmailcount"
      mkdir -p $mail_count_directory

      mail_count_file="$mail_count_directory"/"$mail_account"

      new_count=$(find $account_maildir/Inbox/new -type f | wc -l)
      if [[ $new_count > 0 ]]; then
        echo $new_count > "$mail_count_file"
      else
        if [[ -f "$mail_count_file" ]]; then
          rm "$mail_count_file"
        fi
      fi
    '';
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
        wait = 10;
        tlsOption = {
          starttls = true;
        };
      };

      onNotify = ''
        ${pkgs.isync}/bin/mbsync protonmail
      '';

      onNotifyPost = ''
        ${pkgs.notmuch}/bin/notmuch new; ${new-mail-counter}/bin/new-mail-counter; ${pkgs.libnotify}/bin/notify-send --icon=${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/status/mail-unread-symbolic.svg "You've got mail (`cat ${config.home.homeDirectory}/.cache/newmailcount/protonmail`)" "New e-mail arrived in the protonmail account."
      '';
    };

    notmuch = {
      enable = true;
      neomutt = {
        enable = true;
      };
    };

    neomutt = {
      enable = true;
      extraMailboxes = [ "Starred" "Archive" folders.sent folders.drafts folders.trash "Spam" ];
      extraConfig = ''
        set pgp_default_key = "${gpg.key}"
        set pgp_self_encrypt = yes
      '';
    };
  };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.imapnotify = {
    enable = true;
    package = (pkgs.goimapnotify.overrideAttrs(old: {
      src = pkgs.fetchFromGitLab {
        owner = "rafaelrc7";
        repo = "goimapnotify";
        rev = "2.3.x";
        sha256 = "sha256-RGEHKOmJqy9Cz5GWfck3VBZD6Q3DySoTYg0+Do4sy/4=";
      };
    }));
  };
  programs.notmuch.enable = true;

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
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 20";
        ExecStart = "${config.programs.mbsync.package}/bin/mbsync -Va";
        ExecStartPost = "${pkgs.notmuch}/bin/notmuch new";
        Restart = "on-failure";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
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
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
      Restart = "always";
    };

    Install.WantedBy = [ "default.target" ];
  };
}


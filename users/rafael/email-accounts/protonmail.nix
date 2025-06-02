args@{
  pkgs,
  config,
  lib,
  ...
}:
let
  email-utils = import ../../../modules/home/email/email-utils.nix args;
  protonmail-bridge-pass = pkgs.writeShellScriptBin "protonmail-bridge-pass" ''
    ${pkgs.libsecret}/bin/secret-tool lookup protonmail-bridge password
  '';

  # Must be manually generated with
  # openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
  certificatesFile = "${config.xdg.dataHome}/certs/protonmail.pem";
in
rec {
  primary = lib.mkDefault true;
  flavor = "plain"; # protonmail, if needed

  # Identity
  realName = "Rafael Carvalho";
  address = "contact@rafaelrc.com";
  aliases = [
    "rafaelrc7@proton.me"
    "rafaelrc7@pm.me"
  ];

  gpg = {
    key = "31DE9B4380A123E50CA4B834227EF83D7E920D08";
    encryptByDefault = false;
    signByDefault = false;
  };

  signature = {
    showSignature = "append";
    text = ''
      att.
        Rafael Carvalho

        pgp key: https://pgp.rafaelrc.com
    '';
  };

  folders = {
    inbox = "Inbox";
    sent = "Sent";
    drafts = "Drafts";
    trash = "Trash";
  };

  # Credentials
  userName = "contact@rafaelrc.com";
  passwordCommand = ''${protonmail-bridge-pass}/bin/protonmail-bridge-pass'';

  # IMAP / SMTP
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
  msmtp.enable = config.programs.msmtp.enable;

  notmuch.enable = config.programs.notmuch.enable;

  mbsync = {
    enable = config.programs.mbsync.enable;
    create = "maildir";
  };

  imapnotify = {
    enable = config.services.imapnotify.enable;
    boxes = [ "INBOX" ];
    onNotify = ''${lib.getExe email-utils.sync-mail} protonmail'';
    onNotifyPost = ''${lib.getExe email-utils.notify-new-mail} protonmail'';
  };

  notmuch.neomutt.enable = config.programs.notmuch.enable && config.programs.neomutt.enable;
  neomutt = {
    enable = config.programs.neomutt.enable;
    extraMailboxes = [
      "Starred"
      "Archive"
      folders.sent
      folders.drafts
      folders.trash
      "Spam"
    ];

    extraConfig = ''
      # protonmail-bridge already saves sent email to Sent.
      set copy = no
    '';
  };
}

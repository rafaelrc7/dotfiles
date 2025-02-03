{
  pkgs,
  config,
  email-utils,
  lib,
  ...
}:
let
  protonmail-bridge-pass = pkgs.writeShellScriptBin "protonmail-bridge-pass" ''
    ${pkgs.libsecret}/bin/secret-tool lookup protonmail-bridge password
  '';

  # Must be manually generated with
  # openssl s_client -starttls imap -connect 127.0.0.1:1143 -showcerts
  certificatesFile = "${config.xdg.dataHome}/certs/protonmail.crt";
in
{
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
    encryptByDefault = true;
    signByDefault = true;
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
  msmtp.enable = true;

  notmuch.enable = true;

  mbsync = {
    enable = true;
    create = "maildir";
  };

  imapnotify = {
    enable = true;
    boxes = [ "INBOX" ];
    onNotify = ''${email-utils.sync-mail}/bin/sync-mail protonmail'';
    onNotifyPost = ''${email-utils.notify-new-mail}/bin/notify-new-mail protonmail'';
  };
}

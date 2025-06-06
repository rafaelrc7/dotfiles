args@{
  pkgs,
  config,
  lib,
  ...
}:
let
  email-utils = import ../../../modules/home/email/email-utils.nix args;
  mailbox-pass = pkgs.writeShellScriptBin "mailbox-pass" ''
    ${pkgs.libsecret}/bin/secret-tool lookup mailbox-org password
  '';
in
rec {
  primary = lib.mkDefault true;
  flavor = "plain";

  # Identity
  realName = "Rafael Carvalho";
  address = "contact@rafaelrc.com";
  aliases = [
    "rafaelrc@mailbox.org"
  ];

  gpg = {
    key = "31DE9B4380A123E50CA4B834227EF83D7E920D08";
    encryptByDefault = true;
    signByDefault = true;
  };

  signature = {
    showSignature = "append";
    text = ''
      sds,
        Rafael Carvalho
    '';
  };

  # Credentials
  userName = "contact@rafaelrc.com";
  passwordCommand = lib.getExe mailbox-pass;

  # IMAP / SMTP
  imap = {
    host = "imap.mailbox.org";
    port = 993;
    tls.enable = true;
  };

  smtp = {
    host = "smtp.mailbox.org";
    port = 465;
    tls.enable = true;
  };

  # Tools
  msmtp.enable = config.programs.msmtp.enable;

  notmuch = {
    enable = config.programs.notmuch.enable;
    neomutt = {
      enable = config.programs.notmuch.enable && config.programs.neomutt.enable;
      virtualMailboxes = [
        {
          name = "All";
          query = "folder:/mailbox/Inbox/ or folder:/mailbox/Archive/";
        }
        {
          name = "Unread";
          query = "folder:/mailbox/Inbox/ and tag:unread";
        }
      ];
    };
  };

  mbsync = {
    enable = config.programs.mbsync.enable;
    create = "maildir";
    expunge = "both";
  };

  imapnotify = {
    enable = config.services.imapnotify.enable;
    boxes = [ "Inbox" ];
    onNotify = ''${lib.getExe email-utils.sync-mail} mailbox'';
    onNotifyPost = ''${lib.getExe email-utils.notify-new-mail} mailbox'';
  };

  neomutt = {
    enable = config.programs.neomutt.enable;
    extraConfig = ''
      set crypt_auto_sign = yes
      set pgp_default_key = ${gpg.key}
    '';
  };

}

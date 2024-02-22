{ pkgs, config, email-utils, ... }:
let
  tecgraf-pass = pkgs.writeShellScriptBin "tecgraf-pass" ''
    ${pkgs.libsecret}/bin/secret-tool lookup tecgraf-gmail password
  '';
in
rec {
  # Identity
  realName = "Rafael Carvalho";
  address = "rafaelrc@tecgraf.puc-rio.br";

  signature = {
    showSignature = "append";
    text = ''
      att.
        Rafael Carvalho
    '';
  };

  # Credentials
  passwordCommand = ''${tecgraf-pass}/bin/tecgraf-pass'';

  # IMAP / SMTP
  flavor = "gmail.com";
  imap.tls.enable = true;
  smtp.tls.enable = true;

  # Tools
  msmtp.enable = true;

  notmuch.enable = true;

  mbsync = {
    enable = true;
    create = "maildir";
  };

  imapnotify = {
    enable = true;
    extraConfig = {
      wait = 5;
    };
    onNotify = ''${email-utils.sync-mail}/bin/sync-mail tecgraf'';
    onNotifyPost = ''${email-utils.notify-new-mail}/bin/notify-new-mail tecgraf'';
  };
}


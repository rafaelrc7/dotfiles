{
  pkgs,
  config,
  lib,
  ...
}:
let
  pass = pkgs.pass.withExtensions (
    exts: with exts; [
      pass-audit
      pass-genphrase
      pass-otp
      pass-update
    ]
  );
  passff-otp-host = pkgs.passff-host.override { pass = pass; };
in
{
  programs.password-store = {
    enable = true;
    package = pass;
    settings = {
      PASSWORD_STORE_DIR = lib.mkDefault "${config.xdg.dataHome}/password-store";
    };
  };

  home.file.".mozilla/native-messaging-hosts/passff.json" = {
    enable = config.programs.firefox.enable;
    source = "${passff-otp-host}/share/passff-host/passff.json";
  };

  home.file.".librewolf/native-messaging-hosts/passff.json" = {
    enable = config.programs.librewolf.enable;
    source = "${passff-otp-host}/share/passff-host/passff.json";
  };
}

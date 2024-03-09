{ pkgs, config, lib, ... }:
let
  pass-otp = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  passff-otp-host = pkgs.passff-host.override { pass = pass-otp; };
in
{
  programs.password-store = {
    enable = true;
    package = pass-otp;
    settings = {
      PASSWORD_STORE_DIR = lib.mkDefault "${config.xdg.dataHome}/password-store";
    };
  };

  home.file.".mozilla/native-messaging-hosts/passff.json".source =
    "${passff-otp-host}/share/passff-host/passff.json";

  home.file.".librewolf/native-messaging-hosts/passff.json".source =
    "${passff-otp-host}/share/passff-host/passff.json";
}


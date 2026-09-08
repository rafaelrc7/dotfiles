{ pkgs, ... }:
{
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.dbus.packages = [ pkgs.gcr_3 ];
  environment.systemPackages = [ pkgs.gcr_3 ];
}

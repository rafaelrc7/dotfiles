{ pkgs, ... }:
{
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.dbus.packages = [ pkgs.gcr ];
  environment.systemPackages = [ pkgs.gcr ];
}

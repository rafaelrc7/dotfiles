{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gparted-full ];
}

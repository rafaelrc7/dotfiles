{ pkgs, ... }:
{
  programs.adb.enable = true;
  services.gvfs.enable = true;
  environment.systemPackages = with pkgs; [ jmtpfs ];
}

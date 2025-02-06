{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  systemd.services.brightness = {
    enable = true;
    script = ''
      ${pkgs.brightnessctl}/bin/brightnessctl set 30%
    '';
    wantedBy = [ "multi-user.target" ];
  };
}

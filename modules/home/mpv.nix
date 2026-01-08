{ config, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      gpu-api = "vulkan";
      hwdec = "auto";
      keep-open = "yes";
      profile = "high-quality";
      save-position-on-quit = "yes";
      target-colorspace-hint = "no";
      vo = "gpu-next";
    };
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      webtorrent-mpv-hook
    ];
  };

  home.file.".mozilla/native-messaging-hosts/ff2mpv.json" = {
    enable = config.programs.firefox.enable;
    source = "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";
  };

  home.file.".librewolf/native-messaging-hosts/ff2mpv.json" = {
    enable = config.programs.librewolf.enable;
    source = "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";
  };
}

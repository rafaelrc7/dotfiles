{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
    };
    scripts = with pkgs.mpvScripts; [
      mpris
      sponsorblock
      webtorrent-mpv-hook
    ];
  };

  home.file.".mozilla/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";

  home.file.".librewolf/native-messaging-hosts/ff2mpv.json".source =
    "${pkgs.ff2mpv}/lib/mozilla/native-messaging-hosts/ff2mpv.json";
}


{ ... }: {
  services.mpd = {
    enable = true;
  };

  programs.ncmpcpp = {
    enable = true;
  };
}


{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.98";
      enable_audio_bell = false;
      scrollback_pager_history_size = 2048;
      mouse_map = "left click ungrabbed no-op";
    };
  };
}


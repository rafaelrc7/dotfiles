{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [ "FiraCode" "Hasklig" "Monoid" "JetBrainsMono" ];
      })

      dejavu_fonts
      fira
      fira-code
      fira-mono
      font-awesome_5
      font-awesome
      roboto
      roboto-mono
      liberation_ttf
      inconsolata
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
    ];

    fontconfig= {
      enable = true;
      defaultFonts = {
        sansSerif = [ "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "FiraCode Nerd Font" ];
        emoji = [ "Font Awesome 5 Free" "Noto Color Emoji" ];
      };
    };
  };
}


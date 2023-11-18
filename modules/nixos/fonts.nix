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
      font-awesome
      roboto
      roboto-mono
      liberation_ttf
      inconsolata
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      symbola
    ];

    fontconfig= {
      enable = true;
      defaultFonts = {
        sansSerif = [ "DejaVu Sans" "Noto Sans" "Font Awesome 6 Free" ];
        serif = [ "DejaVu Serif" "Noto Serif" "Font Awesome 6 Free" ];
        monospace = [ "FiraCode Nerd Font" "Font Awesome 6 Free" ];
        emoji = [ "Noto Color Emoji" "Font Awesome 6 Free" ];
      };
      localConf = ''
        <alias>
            <family>FontAwesome</family>
            <prefer>
                <family>Font Awesome 6 Free</family>
            </prefer>
        </alias>
      '';
    };
  };
}


{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code

      dejavu_fonts
      font-awesome
      roboto
      roboto-serif
      roboto-mono
      liberation_ttf
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    fontconfig = {
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


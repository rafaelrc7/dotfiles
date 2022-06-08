{ config, pkgs, ... }: {
  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.libsForQt5.breeze-gtk;
    size = 16;
    x11.enable = true;
    gtk.enable = true;
  };

  programs.kitty = {
    settings = {
      foreground = "#${config.colorscheme.colors.base05}";
      background = "#${config.colorscheme.colors.base00}";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 10;
      package = pkgs.nerdfonts;
    };
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
    };
    cursorTheme = {
      name = "breeze_cursors";
      package = pkgs.libsForQt5.breeze-gtk;
    };

    gtk2.extraConfig = ''
      gtk-enable-animations=1
      gtk-primary-button-warps-slider=0
      gtk-toolbar-style=3
      gtk-menu-images=1
      gtk-button-images=1
    '';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-menu-images = true;
      gtk-modules = "colorreload-gtk-module:window-decorations-gtk-module";
      gtk-primary-button-warps-slider = false;
      gtk-toolbar-style = 3;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = false;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

}


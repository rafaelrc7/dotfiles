{ config, pkgs, ... }: {
  home.pointerCursor = {
    name = "breeze_cursors";
    package = pkgs.libsForQt5.breeze-qt5;
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

  programs.foot = {
    settings = {
      colors = {
        foreground = "${config.colorscheme.colors.base05}";
        background = "${config.colorscheme.colors.base00}";
      };
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      size = 10;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "breeze_cursors";
      package = pkgs.libsForQt5.breeze-qt5;
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
    style.name = "kvantum"; # set QT_STYLE_OVERRIDE
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugins
    libsForQt5.qtstyleplugin-kvantum
  ];

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Dracula-Solid
    '';

    "Kvantum/Dracula".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula";
    "Kvantum/Dracula-Solid".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-Solid";
    "Kvantum/Dracula-purple".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple";
    "Kvantum/Dracula-purple-solid".source = "${pkgs.dracula-theme}/share/Kvantum/Dracula-purple-solid";
  };
}


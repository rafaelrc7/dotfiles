{ pkgs, ... }: {

  stylix = {
    image = ./imgs/wallpapers/vulcan;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";

    cursor = {
      name = "breeze_cursors";
      package = pkgs.libsForQt5.breeze-qt5;
      size = 16;
    };

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 0.95;
      popups = 1.0;
    };

    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Mono";
        package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };

      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 10;
        popups = 10;
      };

    };


    targets = {
      gtk.enable = true;
      mangohud.enable = true;
      xresources.enable = true;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
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
    platformTheme.name = "qtct";
    style.name = "kvantum";
   };

   home.packages = with pkgs; [
     libsForQt5.qtstyleplugins
     libsForQt5.qtstyleplugin-kvantum
     qt6Packages.qtstyleplugin-kvantum
     libsForQt5.qt5.qtwayland
     qt6.qtwayland
     libsForQt5.qt5ct
     qt6Packages.qt6ct
     catppuccin-papirus-folders
   ];

  xdg.configFile = let
    theme = (pkgs.catppuccin-kvantum.override {
      variant = "Mocha";
      accent = "Blue";
    });
  in {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Mocha-Blue
    '';
    "Kvantum/Catppuccin-Mocha-Blue".source = "${theme}/share/Kvantum/Catppuccin-Mocha-Blue";

    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
    '';
  };

}


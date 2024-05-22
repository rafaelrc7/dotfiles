{ config, lib, pkgs, ... }:
let
  fonts = {
    monospace = {
      name = "FiraCode Nerd Font Mono";
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
    };
    sansSerif = {
      name = "Roboto";
      package = pkgs.roboto;
    };
    serif = {
      name = "Roboto Serif";
      package = pkgs.roboto-serif;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji;
    };
    awesome = {
      name = "Font Awesome 6 Free";
      package = pkgs.font-awesome;
    };

    sizes = {
      applications = 10;
      terminal = 10;
      desktop = 10;
      popups = 10;
    };
  };

  opacity = {
    applications = 1.0;
    terminal = 0.95;
    desktop = 0.95;
    popups = 1.0;
  };

  cursor = {
    name = "breeze_cursors";
    package = pkgs.libsForQt5.breeze-qt5;
    size = 16;
  };
in
{
  home.packages = (with pkgs; [
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5.qtwayland

    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    qt6.qtwayland

    catppuccin-papirus-folders

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
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
    symbola
  ]) ++ [
    fonts.monospace.package
    fonts.sansSerif.package
    fonts.serif.package
    fonts.emoji.package
    fonts.awesome.package
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = with fonts; {
      monospace = [ monospace.name awesome.name "Noto Sans Mono" ];
      sansSerif = [ sansSerif.name awesome.name "Noto Sans" ];
      serif = [ serif.name awesome.name "Noto Serif" ];
      emoji = [ emoji.name awesome.name ];
    };
  };

  xdg.dataFile."fonts".source = config.lib.file.mkOutOfStoreSymlink "/run/current-system/sw/share/X11/fonts";

  catppuccin = {
    accent = "blue";
    flavour = "mocha";
  };

  programs = {
    bat = {
      enable = true;
      catppuccin.enable = true;
    };
    btop.catppuccin.enable = true;
    git.delta.catppuccin.enable = true;
    fzf.catppuccin.enable = true;
    imv.catppuccin.enable = true;
    mpv.catppuccin.enable = true;
    neovim.catppuccin.enable = true;
    # swaylock.catppuccin.enable = true;
    tmux.catppuccin.enable = true;
    waybar.catppuccin.enable = true;
    zathura.catppuccin.enable = true;
    zsh.syntaxHighlighting.catppuccin.enable = true;
  };

  services = {
    mako.catppuccin.enable = true;
  };

  i18n.inputMethod.fcitx5.catppuccin.enable = true;

  wayland.windowManager = {
    hyprland = {
      catppuccin.enable = true;
      settings = with fonts; {
        group.groupbar = {
          font_family = sansSerif.name;
          font_size = sizes.desktop;
        };
        misc.splash_font_family = sansSerif.name;
      };
    };

    sway = {
      catppuccin.enable = true;
      config = {
        fonts = {
          names = [ fonts.sansSerif.name fonts.awesome.name ];
          size = fonts.sizes.desktop + 0.0;
        };
      };
    };
  };

  programs.foot = {
    catppuccin.enable = true;
    settings = {
      main = {
        font =
          let size = builtins.toString fonts.sizes.terminal;
          in "${fonts.monospace.name}:size=${size}, ${fonts.awesome.name}:size=${size}, ${fonts.emoji.name}:size=${size}";
      };
      colors.alpha = opacity.terminal;
    };
  };

  programs.kitty = {
    catppuccin.enable = true;
    font = {
      inherit (fonts.monospace) name package;
      size = fonts.sizes.terminal;
    };
    settings.background_opacity = builtins.toString opacity.terminal;
  };

  home.pointerCursor = {
    inherit (cursor) name package size;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    catppuccin.enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };

    font = {
      inherit (fonts.sansSerif) package name;
      size = fonts.sizes.applications;
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

  xdg.configFile =
    let
      capitalise = str:
        let
          cs = (lib.stringToCharacters str);
          hd = lib.head cs; # Errors on empty string, this is intended
          tl = lib.tail cs;
        in
        lib.strings.concatStrings ([ (lib.strings.toUpper hd) ] ++ tl);
      variant = capitalise config.catppuccin.flavour;
      accent = capitalise config.catppuccin.accent;
      theme = (pkgs.catppuccin-kvantum.override { inherit variant accent; });
    in
    {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-${variant}-${accent}
      '';
      "Kvantum/Catppuccin-${variant}-${accent}".source = "${theme}/share/Kvantum/Catppuccin-${variant}-${accent}";

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


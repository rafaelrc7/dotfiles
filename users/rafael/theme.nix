{ pkgs, ... }:
let
  fonts = {
    monospace = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-code;
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

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
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

    catppuccin = {
      enable = true;
      icon.enable = true;
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
    style.catppuccin = {
      enable = true;
      apply = true;
    };
  };

  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=Papirus-Dark
    '';
  };

  programs.waybar.style = ''
    * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: "${fonts.sansSerif.name}", "${fonts.awesome.name}";
        font-size: ${builtins.toString fonts.sizes.desktop}pt;
        min-height: 0;
        font-weight: bold;
    }

    window#waybar {
        background-color: alpha(@base, ${builtins.toString opacity.desktop});
        color: @text;
        transition-property: background-color;
        transition-duration: .5s;
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
        color: @text;
    }

    #workspaces button {
    	padding: 0 5px;
    	background-color: @base;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover,
    #workspaces button:hover
    {
        background-color: @crust;
        box-shadow: inset 0 -3px @blue;
    }

    #workspaces button.focused,
    #workspaces button.active
    {
    	color: @base;
    	background-color: @blue;
    	box-shadow: inset 0 -3px @text;
    }

    #workspaces button.urgent {
        background-color: @red;
    	color: @base;
    }

    #window,
    #workspaces {
        margin: 0 4px;
    }

    #mode,
    #submap,
    #scratchpad,
    #clock,
    #tray,
    #custom-weather,
    #mpd,
    #pulseaudio,
    #privacy,
    #network,
    #cpu,
    #memory,
    #temperature,
    #battery,
    #idle_inhibitor,
    #backlight,
    #keyboard-state,
    #language
    {
    	color: @text;
        padding: 2px 5px;
        margin: 2px 2px;
    }

    #clock
    {
    	background-color: @blue;
    	color: @base;
    	border-radius: 30px;
    	padding: 2px 20px;
        margin: 3px 10px;
    }

    #tray
    {
    	border-radius: 30px 0 0 30px;
    }

    #window {
    	border-radius: 0 30px 30px 0;
    }

    #window,
    #tray
    {
    	color: @base;
    	background-color: @blue;
    	padding: 2px 15px;
        margin: 3px 10px;
    }

    #custom-weather
    {
    	color: @flamingo;
    	border-bottom: solid 2px @flamingo;
    }

    #mpd,
    #pulseaudio
    {
    	color: @yellow;
    	border-bottom: solid 2px @yellow;
    }

    #mpd.disconnected
    {
    	color: @red;
    	border-bottom: @red;
    }

    #mpd.stopped,
    #mpd.paused
    {
    	color: @subtext0;
    	border-color: @subtext0;
    }

    #pulseaudio.muted {
    	color: @subtext0;
    	border-color: @subtext0;
    }

    #privacy
    {
    	color: @peach;
    	border-bottom: solid 2px @peach;
    }

    #network,
    #cpu,
    #memory,
    #battery
    {
    	color: @green;
    	border-bottom: solid 2px @green;
    }

    #network.disconnected {
    	color: @red;
    	border-color: @red;
    }

    #temperature
    {
    	color: @sapphire;
    	border-bottom: solid 2px @sapphire;
    }

    #temperature.critical {
        background-color: @red;
        color: @base;
    }

    #battery.charging, #battery.plugged {
    }

    #battery.critical:not(.charging) {
        background-color: @red;
        color: @base;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #idle_inhibitor,
    #backlight
    {
    	color: @marron;
    	border-bottom: solid 2px @marron;
    }

    #idle_inhibitor {
        min-width: 1rem;
    }

    #idle_inhibitor.activated {
    	background-color: @overlay0;
    }

    #keyboard-state,
    #language
    {
    	color: @lavender;
    	border-bottom: solid 2px @lavender;
        min-width: 16px;
    }

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    @keyframes blink {
        to {
            background-color: @text;
            color: @crust;
        }
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
    }
  '';

}


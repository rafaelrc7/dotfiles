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
    platformTheme = "qtct";
    # style.name = "kvantum"; # set QT_STYLE_OVERRIDE
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugins
    libsForQt5.qtstyleplugin-kvantum  qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qt5.qtwayland          qt6.qtwayland
    libsForQt5.qt5ct                  qt6Packages.qt6ct
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

    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=Dracula
      standard_dialogs=default
      style=kvantum

      [Fonts]
      fixed="DejaVu Sans,12,-1,5,50,0,0,0,0,0"
      general="DejaVu Sans,12,-1,5,50,0,0,0,0,0"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x4\xf9\0\0\x4\x1a\0\0\0\0\0\0\0\0\0\0\x2\xde\0\0\x2\xd9\0\0\0\0\x2\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\x4\xf9\0\0\x4\x1a)

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      custom_palette=false
      icon_theme=Dracula
      standard_dialogs=default
      style=kvantum

      [Fonts]
      fixed="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      general="DejaVu Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
  };
}


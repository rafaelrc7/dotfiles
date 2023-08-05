{ pkgs, lib, ... }: {
  xdg.configFile."sway/wallpaper".source = ./imgs/wallpaper.png;

  wayland.windowManager.sway = rec {
    enable = true;
    package = null; # Installed through nixos
    config = rec {
      ## Keyboard ##
      modifier = "Mod4";
      left = "h"; right = "l"; up = "k"; down = "j";
      input = {
        "*" = {
          xkb_layout = "br";
          xkb_model = "abnt2";
          xkb_variant = "abnt2";
        };
      };

      ## Startup ##
      startup = [
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.swaybg}/bin/swaybg -i ~/.config/sway/wallpaper -m fill"; }
      ];

      ## Programs/Addons ##
      terminal = "${pkgs.foot}/bin/foot";
      menu = "${pkgs.wofi}/bin/wofi --show=drun --insensitive --allow-images --hide-scroll | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      ## Keybindings ##
      keybindings = lib.mkOptionDefault {

      };

      ## Workspaces ##
      workspaceAutoBackAndForth = true;
      workspaceLayout = "default";

      ## Decorations ##
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 4;
        outer = 0;
        top = 0;
      };

      floating = {
        border = 2;
        titlebar = true;
      };

      window = {
        border = 2;
        titlebar = false;
        hideEdgeBorders = "none";
      };

      fonts = {
        names = [ "FiraCode Nerd Font" ];
        size = 8.0;
      };

      ## Focus ##
      focus = {
        followMouse = true;
        wrapping = "no";
        mouseWarping = true;
        newWindow = "smart";
      };

      ## Program Specifc Settings ##
      floating.criteria = [

      ];

    };

    extraConfigEarly = ''
    '';

    extraConfig = ''
    '';

    extraSessionCommands = ''
    '';

    systemd.enable = true;
    wrapperFeatures.gtk = true;
    xwayland = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "FiraCode Nerd Font Mono:size=11";
        dpi-aware = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}


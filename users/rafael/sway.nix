{ pkgs, lib, ... }: {
  xdg.configFile."sway/wallpaper".source = ./imgs/wallpaper.png;

  wayland.windowManager.sway = let
    terminal    = "${pkgs.foot}/bin/foot";
    browser     = "${pkgs.librewolf}/bin/librewolf";
    fileManager = "${pkgs.dolphin}/bin/dolphin";
    screenlock  = "${pkgs.swaylock}/bin/swaylock -Ffk";
    printClip   = "slurp | grim -g - - | wl-copy";
    mod         = "Mod4";
    alt         = "Mod1";
  in rec {
    enable = true;
    package = null; # Installed through nixos
    config = rec {
      ## Keyboard ##
      modifier = mod;
      floating.modifier = mod;
      left = "h"; right = "l"; down = "j"; up = "k";
      input = {
        "*" = {
          xkb_layout = "br";
          xkb_model = "abnt2";
          xkb_variant = "abnt2";
        };
      };

      ## Startup ##
      startup = [
        { command = "--no-startup-id ${pkgs.mako}/bin/mako"; }
        { command = "--no-startup-id ${fileManager} --daemon"; }
        { command = "--no-startup-id ${pkgs.swaybg}/bin/swaybg -i ~/.config/sway/wallpaper -m fill"; }
      ];

      ## Programs/Addons ##
      inherit terminal;
      menu = "${pkgs.wofi}/bin/wofi --show=drun --insensitive --allow-images --hide-scroll | ${pkgs.findutils}/bin/xargs swaymsg exec --";

      ## Keybindings ##
      keybindings = lib.mkOptionDefault {
        "ctrl+${alt}+l" = "exec --no-startup-id ${screenlock}";
        "${mod}+q"      = "exec ${browser}";
        "${mod}+e"      = "exec ${fileManager}";
        "Print"         = "exec ${printClip}";

        "ctrl+${mod}+space" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

        "XF86AudioPlay"              = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioStop"              = "exec ${pkgs.playerctl}/bin/playerctl stop";
        "XF86AudioPrev"              = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext"              = "exec ${pkgs.playerctl}/bin/playerctl next";
        "shift+XF86AudioPrev"        = "exec ${pkgs.playerctl}/bin/playerctl position 10-";
        "shift+XF86AudioNext"        = "exec ${pkgs.playerctl}/bin/playerctl position 10+";
        "shift+XF86AudioLowerVolume" = "exec ${pkgs.playerctl}/bin/playerctl volume 0.1-";
        "shift+XF86AudioRaiseVolume" = "exec ${pkgs.playerctl}/bin/playerctl volume 0.1+";

        "XF86AudioMute"        = "exec ${pkgs.pamixer}/bin/pamixer -t";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";

        "XF86MonBrightnessUp"   = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%+";
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
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
        commands = [ ];
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
        { window_role = "pop-up";      }
        { window_role = "bubble";      }
        { window_role = "task_dialog"; }
        { window_role = "Preferences"; }

        { window_type = "dialog"; }
        { window_type = "menu"; }
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

  services.playerctld.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -Ffk"; }
      { timeout = 600; command = "${pkgs.sway}/bin/swaymsg \"output * power off\""; }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -Ffk"; }
      { event = "after-resume";       command = "${pkgs.sway}/bin/swaymsg \"output * power on\""; }
    ];
  };
}


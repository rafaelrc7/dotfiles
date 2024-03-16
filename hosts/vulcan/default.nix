{ self, ... }: with self.nixosModules;
{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "vulcan";

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = with inputs; [
    ./hardware-configuration.nix
    ./networking.nix

    common
    android
    boot
    btrfs
    flatpak
    geoclue
    gnome-keyring
    libvirtd
    lutris
    mullvad
    nix
    pipewire
    steam
    zsh
    podman
    fonts
    cryptswap
    man
    ssh
    git
    polkit
    tailscale
    waydroid
    systemd-oomd

    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  environment = {
    systemPackages = with pkgs; [
      dbeaver
      libva-utils
      lutris
      glxinfo
      xclip
      wineWowPackages.staging
      winetricks
      protontricks
      qbittorrent
      zoom
    ];
  };

  programs.java.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl

        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.vaapiVdpau
        driversi686Linux.libvdpau-va-gl
      ];
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    AMD_VULKAN_ICD = "RADV";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  services.xserver = {
    enable = false;

    displayManager = {
      lightdm = {
        enable = false;
        greeters.gtk = {
          enable = true;
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
        };
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      [ -e $HOME/.zshenv ] && . $HOME/.zshenv
      [ -e $HOME/.profile ] && . $HOME/.profile

      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND="wayland"
      export XDG_SESSION_TYPE="wayland"

      export TERMINAL="foot"

      # For flatpak to be able to use PATH programs
      sh -c "systemctl --user import-environment PATH" &
    '';
  };

  security.pam.services.swaylock = { };
  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    xdgOpenUsePortal = true;
  };

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all peer
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr pkgs.epson_201207w ];
      browsing = true;
      startWhenNeeded = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
      publish.addresses = true;
      publish.userServices = true;
    };
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epson-escpr ];
  };

  programs.dconf.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  system.stateVersion = "22.11";
}


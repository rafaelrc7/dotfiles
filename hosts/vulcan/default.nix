{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "vulcan";

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernel.sysctl."kernel.sysrq" = 1;

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
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

  services.gnome.gnome-keyring.enable = true;

  console.keyMap = "br-abnt2";
  services.xserver = {
    layout = "br";
    xkbModel = "abnt2";
    xkbVariant = "abnt2";
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
    enable = true;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm = {
        enable = true;
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

  security.polkit.enable = true;

  xdg.portal= {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
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
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
      publish.userServices= true;
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
    pinentryFlavor = "qt";
  };

  system.stateVersion = "22.11";
}


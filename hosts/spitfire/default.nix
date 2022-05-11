{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  networking.hostName = "spitfire";

  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  users = {
    users.rafael = {
      isNormalUser = true;
      createHome = true;
      group = "rafael";
      extraGroups = [ "wheel" ];
    };

    groups.rafael.gid = config.users.users.rafael.uid;
  };

  services.xserver = {
    enable = true;

    displayManager = {
      defaultSession = "none+awesome";
      lightdm.enable = true;
    };
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
    enableSSHSupport = true;
  };

  system.stateVersion = "22.05";
}


{ config, inputs, pkgs, nixpkgs, home-manager, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 3;

    systemd-boot = {
      enable= true;
      consoleMode = "max";
      editor = false;
      memtest86.enable = true;
    };
  };

  boot.cleanTmpDir = true;

  boot.initrd.supportedFilesystems = [ "btrfs" ];

  swapDevices = [
    { device = "/dev/disk/by-partlabel/cryptswap"; randomEncryption.enable = true; }
  ];

  fileSystems."/".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];
  fileSystems."/root".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];
  fileSystems."/var".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];
  fileSystems."/tmp".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];
  fileSystems."/.snapshots".options = [ "compress=zstd" "noatime" "nodiratime" "discard" "ssd" ];

  networking.hostName = "vulkan";

  time.timeZone = "America/Sao_Paulo";

  users = {
    mutableUsers = true;

    users.rafael = {
      isNormalUser = true;
      createHome = true;
      group = "rafael";
      extraGroups = [ "wheel" ];
    };

    groups.rafael.gid = 1000;

    defaultUserShell = pkgs.zsh;
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "pt_BR.UTF-8/UTF-8" ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;

    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };

    windowManager.awesome = {
      enable = true;
      package = pkgs.awesome.overrideAttrs (old: {
        version = "git";
        src = inputs.awesome-git;
      });
    };

    layout = "us";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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

  environment = {

    systemPackages = with pkgs; [
      btrfs-progs
      exfat
      file
      git-lfs
      gitAndTools.gitFull
      gnumake
      htop
      killall
      neovim
      parted
      tree
      unzip
      usbutils
      wget
    ];
    shells = with pkgs; [ bashInteractive zsh ];
    variables = { EDITOR = "nvim"; };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
  };

  programs.zsh.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.useDHCP = false;

  systemd.network = {
    enable = true;

    netdevs = {
      "10-bond0" = {
        enable = true;
        netdevConfig = {
          Name = "bond0";
          Kind = "bond";
        };
        bondConfig = {
          Mode = "active-backup";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };
    };

    networks = {
      "10-bond0" = {
        enable = true;
        matchConfig.Name = "bond0";
        DHCP = "yes";
        dhcpV4Config = {
          UseDNS = false;
          Anonymize = true;
        };
        networkConfig.IPv6PrivacyExtensions = "prefer-public";
        dns = [ "127.0.0.1" "::1" ];
      };

      "10-ethernet-bond0" = {
        enable = true;
        matchConfig.Name = "enp*";
        bond = [ "bond0" ];
        networkConfig.PrimarySlave = true;
      };

      "10-wifi-bond0" = {
        enable = true;
        matchConfig.Name = "wlan*";
        bond = [ "bond0" ];
      };
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };

    wireless.iwd.enable = true;
  };


  system.stateVersion = "22.05";

}


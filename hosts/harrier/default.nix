# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "harrier"; # Define your hostname.

  boot = {
    loader = {
      raspberryPi = {
        enable = false;
        version = 3;
      };

      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.enableRedistributableFirmware = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;




  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libraspberrypi
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.permitRootLogin = lib.mkForce "prohibit-password";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuNeXyzzmI/4xmSJ6rw5Ggr3M/eGPZJ47WqPEy6qYMG3hhpmJFzLBaH/n+Qq6ySRU85VqenTgkz6cMD8hWDG+RtnS0rQTqqVUQLi2W3aQ425KCgZEj+nOXIvniyE2S2qJcz0zOeY++mab69ByanKLblYjrsdJSHEFiep+Dijy1ayRXgKSjc7kW7fk75hskKBx2q5KYgPtoCR4HcTdiJZLiin0LDfyO+NcAaZiuXXvdcpcses8Gm63Vfd5eTxi3mYnjnbDhGo58LeImSIc34xIUxnP8/33MR+9YwHrHbp1gMI/DrRcgpRVOqfrnEp/7S0drVF4T7f6k9L2vsyu8Z9XBnvXTcWPv7UhY5KysLT/FKGf1UyhUVIuMJBtTQUKoGHh9xRqOOVyxreQz7UiRXOm41mU0bOKhnl4LXDX+TIuJjZdZ0+FCBWP0PJXYC1ZoqhLfev2pv4xUsN2aETtFGRPRhmpy89JxYNj/h0VdjVfTuv/eXXgkJq8bv4PGRchUZG8= rafael@arch-desktop"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}


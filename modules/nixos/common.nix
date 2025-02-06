{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernel.sysctl."kernel.sysrq" = 1;
    tmp.cleanOnBoot = true;
    supportedFilesystems = [
      "vfat"
      "btrfs"
      "ext4 "
    ];
  };

  time.timeZone = lib.mkDefault "America/Sao_Paulo";
  i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = lib.mkDefault true;
  };

  services.xserver.xkb = lib.mkDefault {
    layout = "us";
    variant = "intl";
  };

  environment = {
    systemPackages = with pkgs; [
      exfat
      file
      gnumake
      htop
      killall
      fastfetch
      parted
      ripgrep
      tree
      unzip
      usbutils
      wget
    ];
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;
  };

  programs.dconf.enable = true;
  programs.mtr.enable = true;

  security.pam.services.swaylock = { };
  security.pam.services.hyprlock = { };
  security.pam.services.login.enableGnomeKeyring = true;
  services.dbus.packages = [
    pkgs.gnome-keyring
    pkgs.gcr
  ];

  systemd.services.lock-on-sleep = {
    wantedBy = [ "sleep.target" ];
    unitConfig = {
      Description = "Lock session on sleep";
      Before = "sleep.target";
    };
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "no";
      ExecStart = "${pkgs.systemd}/bin/loginctl lock-sessions";
    };
  };

  services.udisks2.enable = true;
  services.dbus.enable = true;

  security.pki.certificateFiles = [
    ./rootCA.crt
  ];
}

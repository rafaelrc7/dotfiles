{ pkgs, lib, ... }:
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_GB.UTF-8";

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

  environment = {
    systemPackages = with pkgs; [
      exfat
      file
      git-lfs
      gitAndTools.gitFull
      gnumake
      htop
      killall
      man-pages
      man-pages-posix
      fastfetch
      neovim
      parted
      ripgrep
      stdmanpages
      tree
      unzip
      usbutils
      wget
    ];
    variables = {
      EDITOR = "nvim";
    };
  };

  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = lib.mkDefault true;
  };

  services.xserver.xkb = lib.mkDefault {
    layout = "us";
    variant = "intl";
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

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

{ pkgs, lib, ... }: {
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_GB.UTF-8";

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
      neofetch
      neovim
      parted
      ripgrep
      stdmanpages
      tmux
      tree
      unzip
      usbutils
      wget
    ];
    variables = { EDITOR = "nvim"; };
  };

  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = lib.mkDefault true;
  };

  services.xserver = {
    layout = lib.mkDefault "us";
    xkbVariant = lib.mkDefault "intl";
  };
}


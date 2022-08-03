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
    shells = with pkgs; [ bashInteractive zsh ];
    variables = { EDITOR = "nvim"; };
  };

  users = {
    defaultUserShell = pkgs.zsh;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
  };

  documentation = {
    man.enable = true;
    dev.enable = true;
    nixos.enable = true;
  };

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}


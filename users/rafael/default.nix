{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = [
    inputs.nix-colors.homeManagerModule
    ./environment_variables.nix
  ];

  colorscheme = inputs.nix-colors.colorSchemes.nord;

  home.packages = with pkgs; [
    gcc
    ripgrep
    speedtest-cli
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  xdg.enable = true;
  xdg.userDirs = {
      enable = true;
      createDirectories = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
      "aur.archlinux.org" = {
        identityFile = "$HOME/.ssh/aur";
        user = "aur";
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.05";
}


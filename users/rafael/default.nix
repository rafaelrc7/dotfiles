{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = [
    inputs.awesomerc.setup
    inputs.nix-colors.homeManagerModule
    ./environment_variables.nix
    ./neovim.nix
    ../../modules/home/zsh.nix
  ];

  colorscheme = inputs.nix-colors.colorSchemes.nord;

  home.packages = with pkgs; [
    gcc
    ripgrep
    speedtest-cli
  ];

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/${config.programs.go.goPath}/bin" ];

  xdg.enable = true;
  xdg.userDirs = {
      enable = true;
      createDirectories = true;
  };

  programs.git = {
    enable = true;
    userName = "rafaelrc7";
    userEmail = "rafaelrc7@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      user.editor = "nvim";
      delta.navigate = true;
      merge.conflictStyle = "diff3";
      pull.rebase = true;
    };
    signing = {
      signByDefault = true;
      key = "03F104A08E5D7DFE";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
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

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_KEY = "03F104A08E5D7DFE";
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  services.mpd = {
    enable = true;
  };

  programs.ncmpcpp = {
    enable = true;
  };

  systemd.user.startServices = "sd-switch";
}


{ inputs, config, pkgs, ... }: {

  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  programs.home-manager.enable = true;

  imports = [
    inputs.awesomerc.setup
    ./environment_variables.nix
    ./neovim.nix
    ../../modules/home/zsh.nix
  ];

  home.packages = with pkgs; [
    discord
    gcc
    gimp
    gparted
    jdk
    jetbrains.idea-ultimate
    libreoffice-fresh
    librewolf
    obs-studio
    pavucontrol
    python3
    ripgrep
    slack
    speedtest-cli
    tdesktop
    thunderbird
    ungoogled-chromium
    unityhub
    v4l-utils
    zoom-us
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

  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      background_opacity = "0.95";
      enable_audio_bell = false;
      scrollback_pager_history_size = 2048;
      mouse_map = "left click ungrabbed no-op";
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_KEY = "03F104A08E5D7DFE";
    };
  };

  programs.go = {
    enable = true;
    goPath = ".local/share/go";
  };

  programs.mpv = {
    enable = true;
  };

  services.unclutter = {
    enable = true;
    timeout = 3;
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  services.mpd = {
    enable = true;
  };

  programs.ncmpcpp = {
    enable = true;
  };

  systemd.user.startServices = "sd-switch";
}


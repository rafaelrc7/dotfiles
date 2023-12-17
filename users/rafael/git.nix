{ ... }: {
  programs.git = {
    enable = true;
    userName = "rafaelrc7";
    userEmail = "contact@rafaelrc.com";
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
      key = "161833317F080B3AC3ECFB01A2E6A1C9A59514A5";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  };
}


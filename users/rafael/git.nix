{ ... }: {
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
}


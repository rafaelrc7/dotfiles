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
      key = "A021D05707D44720";
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


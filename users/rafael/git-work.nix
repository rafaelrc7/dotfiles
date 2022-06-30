{ ... }: {
  programs.git = {
    enable = true;
    userName = "Rafael Carvalho";
    userEmail = "rafael.carvalho@visagio.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "master";
      user.editor = "nvim";
      delta.navigate = true;
      merge.conflictStyle = "diff3";
      pull.rebase = true;
    };
  };
}


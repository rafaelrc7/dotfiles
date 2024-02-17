{ ... }: {
  programs.git = {
    enable = true;
    userName = "rafaelrc7";
    userEmail = "contact@rafaelrc.com";
    delta.enable = true;
    extraConfig = {
      delta.navigate = true;
      diff.algorithm = "histogram";
      init.defaultBranch = "master";
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      rebase.autosquash = true;
      rerere.enabled = true;
      user.editor = "vim";
    };
    ignores = [
      "*~"
      "*.swp"
      ".idea"
      ".vscode"
    ];
    signing = {
      signByDefault = true;
      key = "161833317F080B3AC3ECFB01A2E6A1C9A59514A5";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "vim";
      git_protocol = "ssh";
    };
  };
}


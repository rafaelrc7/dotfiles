{ ... }: {
  programs.git = {
    enable = true;
    userName = "Rafael Carvalho";
    userEmail = "rafaelrc@tecgraf.puc-rio.br";
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
      ".direnv"
    ];
  };
}


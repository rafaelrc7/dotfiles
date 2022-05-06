{ ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = false;
    completionInit = "";
  };
}


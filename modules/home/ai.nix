{ ... }: {
  programs.codex = {
    enable = true;
    mutableSettings = true;
    settings = {
      tui = {
        vim_mode_default = true;
      };
    };
  };

  programs.claude-code = {
    enable = true;
  };
}

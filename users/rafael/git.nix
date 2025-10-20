{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "rafaelrc7";
        email = "contact@rafaelrc.com";
      };
      branch.sort = "-committerdate";
      column.ui = "auto";
      commit.verbose = true;
      core = {
        fsmonitor = true;
        untrackedcache = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        all = true;
        pruneTags = true;
        prune = true;
      };
      help.autocorrect = "prompt";
      init.defaultBranch = "master";
      merge.conflictStyle = "zdiff3";
      pull.rebase = true;
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      tag.sort = "version:refname";
      user.editor = "vim";
    };
    ignores = [
      "*~"
      "*.swp"
      ".direnv"
    ];
    signing = {
      signByDefault = true;
      key = "161833317F080B3AC3ECFB01A2E6A1C9A59514A5";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
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

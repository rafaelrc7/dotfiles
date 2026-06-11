{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux.shell = lib.getExe config.programs.zsh.package;
  programs.tmux.extraConfig = ''
    set -g default-command ${lib.getExe config.programs.zsh.package}
  '';

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion.enable = true;
    autosuggestion.strategy = [
      "completion"
      "match_prev_cmd"
      "history"
    ];

    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    history = {
      size = 10000;
      expireDuplicatesFirst = true;
      path = "${config.xdg.cacheHome}/zsh/history";
      ignorePatterns = [
        "rm *"
        "pkill *"
      ];
    };

    sessionVariables = { };

    shellAliases = {
      nixdev = "nix develop -c zsh";
    };

    siteFunctions = {
      myprompt = /* zsh */ ''
        if [[ -v IN_NIX_SHELL ]]; then
          PS1="%F{blue}(nix-sh) "
        else
          PS1=""
        fi
        PS1="%B''${PS1}%(!.%F{red}root.%F{cyan}%n)%F{blue}@%F{cyan}%m%F{blue}:%F{cyan}%3~ %(!.%F{red}#.%F{green}$)%b%f "
        RPROMPT="%(?..%B%F{red}<FAIL>%b %?)%f"
      '';

      extract = /* zsh */ ''
        if [ -z "$1" ]; then
          echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        else
          if [ -f "$1" ]; then
            case "$1" in
              *.tar.bz2)   tar xvjf "$1"    ;;
              *.tar.gz)    tar xvzf "$1"    ;;
              *.tar.xz)    tar xvJf "$1"    ;;
              *.lzma)      unlzma "$1"      ;;
              *.bz2)       bunzip2 "$1"     ;;
              *.rar)       unrar x -ad "$1" ;;
              *.gz)        gunzip "$1"      ;;
              *.tar)       tar xvf "$1"     ;;
              *.tbz2)      tar xvjf "$1"    ;;
              *.tgz)       tar xvzf "$1"    ;;
              *.zip)       unzip "$1"       ;;
              *.Z)         uncompress "$1"  ;;
              *.7z)        7z x "$1"        ;;
              *.xz)        unxz "$1"        ;;
              *.exe)       cabextract "$1"  ;;
              *)           echo "extract: '$1' - unknown archive method" ;;
            esac
          else
            echo "$1 - file does not exist"
          fi
        fi
      '';

      foot_title = /* zsh */ ''
        print -Pn "\e]0;$1\a"
      '';

      foot_restore_title = /* zsh */ ''
        print -Pn "\e]0;$TERM\a"
      '';
    };

    plugins = with pkgs; [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "zsh-vi-mode";
        file = "zsh-vi-mode.plugin.zsh";
        src = "${zsh-vi-mode}/share/zsh-vi-mode";
      }
    ];

    initContent =
      let
        initExtraFirst = /* zsh */ ''

        '';

        initExtraBeforeCompInit = /* zsh */ ''
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
          zstyle ':completion:*' menu select
          setopt COMPLETE_ALIASES
          zmodload zsh/complist
        '';

        initExtra = /* zsh */ ''
          # Binds arrows to history search
          autoload -U up-line-or-beginning-search
          autoload -U down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
          bindkey "^[[A" up-line-or-beginning-search
          bindkey "^[OA" up-line-or-beginning-search
          bindkey "^[[B" down-line-or-beginning-search
          bindkey "^[OB" down-line-or-beginning-search

          # Binds arrows and j/k to history search in vim mode
          bindkey -M viins "^[[A" up-line-or-beginning-search
          bindkey -M viins "^[OA" up-line-or-beginning-search
          bindkey -M viins "^[[B" down-line-or-beginning-search
          bindkey -M viins "^[OB" down-line-or-beginning-search
          bindkey -M vicmd "^[[A" up-line-or-beginning-search
          bindkey -M vicmd "^[OA" up-line-or-beginning-search
          bindkey -M vicmd "^[[B" down-line-or-beginning-search
          bindkey -M vicmd "^[OB" down-line-or-beginning-search
          bindkey -M vicmd "k" up-line-or-beginning-search
          bindkey -M vicmd "j" down-line-or-beginning-search

          # Fix home/end/delete
          bindkey "^[[H" beginning-of-line
          bindkey "^[[F" end-of-line
          bindkey "^[[3~" delete-char

          # Vim binds for tab menu
          bindkey -M menuselect 'h' vi-backward-char
          bindkey -M menuselect 'l' vi-forward-char
          bindkey -M menuselect 'j' vi-down-line-or-history
          bindkey -M menuselect 'k' vi-up-line-or-history

          # Prompt
          autoload -U colors && colors

          autoload -Uz add-zsh-hook myprompt && add-zsh-hook precmd myprompt

          case $TERM in
              foot*)
                  autoload -Uz add-zsh-hook foot_title foot_restore_title
                  add-zsh-hook preexec foot_title
                  add-zsh-hook precmd foot_restore_title
              ;;
          esac
        '';

        initExtraAfter = /* zsh */ ''

        '';
      in
      lib.mkMerge [
        (lib.mkBefore initExtraFirst)
        (lib.mkOrder 550 initExtraBeforeCompInit)
        initExtra
        (lib.mkAfter initExtraAfter)
      ];

    loginExtra = /* zsh */ ''
      # Autostart Hyprland
      if which uwsm > /dev/null && uwsm check may-start > /dev/null; then
          exec uwsm start hyprland-uwsm.desktop
      fi

      :
    '';

    logoutExtra = /* zsh */ "";

    profileExtra = /* zsh */ "";

    envExtra = /* zsh */ "";
  };
}

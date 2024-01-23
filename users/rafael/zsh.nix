{ config, pkgs, ... }: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;

    defaultKeymap = "viins";

    history = {
      size = 10000;
      expireDuplicatesFirst = true;
      path = "${config.xdg.cacheHome}/zsh/history";
    };

    shellAliases = {
      diff = "diff --color=auto";
      dmesg = "dmesg --color=always";
      grep = "grep --color=auto";
      ip = "ip --color=auto";
      ls = "ls --color=auto";
      sudo = "sudo "; # Makes commands after sudo keep colour
      matlab = "nix run gitlab:doronbehar/nix-matlab";
      nixdev = "nix develop -c zsh";
      nixsh = "nix shell";
      rm = "rm -I";
      mv = "mv -i";
    };

    plugins = with pkgs; [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = "${zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "zsh-git-prompt";
        file = "zshrc.sh";
        src = "${zsh-git-prompt}/share/zsh-git-prompt";
      }
      {
        name = "zsh-vi-mode";
        file = "zsh-vi-mode.plugin.zsh";
        src = "${zsh-vi-mode}/share/zsh-vi-mode";
      }
    ];

    initExtraBeforeCompInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu select
      setopt COMPLETE_ALIASES
      zmodload zsh/complist
    '';

    initExtraFirst = ''
      # Fix vim cursor on foot
      [ "$TERM" = "foot" ] && export ZVM_TERM="xterm-256color"
    '';

    initExtra = ''
      # Binds arrows to history search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "$key[Up]" up-line-or-beginning-search
      bindkey "$key[Down]" down-line-or-beginning-search

      # Binds arrows and j/k to history search in vim mode
      bindkey -M viins "$key[Up]" up-line-or-beginning-search
      bindkey -M viins "$key[Down]" down-line-or-beginning-search
      bindkey -M vicmd "$key[Up]" up-line-or-beginning-search
      bindkey -M vicmd "$key[Down]" down-line-or-beginning-search
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
      GIT_PROMPT_EXECUTABLE="haskell"

      prompt() {
        [[ -v IN_NIX_SHELL ]] && PS1="%F{blue}(nix-sh) " || PS1=""
        PS1="%B''${PS1}%(!.%F{red}root.%F{cyan}%n)%F{blue}@%F{cyan}%m%F{blue}:%F{cyan}%3~ %(!.%F{red}#.%F{green}$)%b%f "
        RPROMPT="%(?..%B%F{red}<FAIL>%b %?)%f $(git_super_status)"
      }

      precmd_functions+=prompt
    '';

    envExtra = ''
      # Generic extract function
      function extract {
        if [ -z "$1" ]; then
          echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        else
          if [ -f $1 ]; then
            case $1 in
              *.tar.bz2)   tar xvjf $1    ;;
              *.tar.gz)    tar xvzf $1    ;;
              *.tar.xz)    tar xvJf $1    ;;
              *.lzma)      unlzma $1      ;;
              *.bz2)       bunzip2 $1     ;;
              *.rar)       unrar x -ad $1 ;;
              *.gz)        gunzip $1      ;;
              *.tar)       tar xvf $1     ;;
              *.tbz2)      tar xvjf $1    ;;
              *.tgz)       tar xvzf $1    ;;
              *.zip)       unzip $1       ;;
              *.Z)         uncompress $1  ;;
              *.7z)        7z x $1        ;;
              *.xz)        unxz $1        ;;
              *.exe)       cabextract $1  ;;
              *)           echo "extract: '$1' - unknown archive method" ;;
            esac
          else
            echo "$1 - file does not exist"
          fi
        fi
      }
    '';

    loginExtra = ''
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
      [ "$(tty)" = "/dev/tty1" ] && exec sway
      true
    '';
  };
}


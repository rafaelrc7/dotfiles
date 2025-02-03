{ ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    terminal = "screen-256color";
    mouse = true;
    clock24 = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    extraConfig = ''
      set-option -ga terminal-features "xterm-256color:RGB"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind-key -n C-w if-shell "$is_vim" "send-keys C-w" "switch-client -Ttable1"
      bind-key -Ttable1 'h' select-pane -L
      bind-key -Ttable1 'j' select-pane -D
      bind-key -Ttable1 'k' select-pane -U
      bind-key -Ttable1 'l' select-pane -R
      bind-key -r -Ttable1 'H' resize-pane -L
      bind-key -r -Ttable1 'J' resize-pane -D
      bind-key -r -Ttable1 'K' resize-pane -U
      bind-key -r -Ttable1 'L' resize-pane -R
      bind-key -r -Ttable1 '<' resize-pane -L
      bind-key -r -Ttable1 '-' resize-pane -D
      bind-key -r -Ttable1 '+' resize-pane -U
      bind-key -r -Ttable1 '>' resize-pane -R
      bind-key -Ttable1 '\' select-pane -l
      bind-key -Ttable1 's' split-window -v
      bind-key -Ttable1 'v' split-window -h
      bind-key -Ttable1 'C-w' send-keys C-w
    '';
  };
}

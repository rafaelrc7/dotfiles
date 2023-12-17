{ pkgs, config, ... }:
let neomutt_gruvbox = pkgs.fetchFromGitHub {
                        owner = "shuber2";
                        repo = "mutt-gruvbox";
                        rev = "91853cfee609ecad5d2cb7dce821a7dfe6d780ef";
                        hash = "sha256-TFxVG2kp5IDmkhYuzhprEz2IE28AEMAi/rUHILa7OPU=";
                      };
in {
  xdg.configFile."neomutt/mailcap".text = ''
    text/html; $BROWSER %s;
    text/html; ${pkgs.lynx}/bin/lynx -assume_charset=%{charset} -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput
  '';

  programs.neomutt = {
    enable = true;

    vimKeys = true;
    sort = "reverse-date";

    sidebar = {
      enable = true;
      shortPath = true;
    };

    settings = {
      mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";
      forward_format = ''"Fwd: %s"'';
    };

    extraConfig = ''
      set envelope_from
      set edit_headers
      set fast_reply
      set ask_cc
      set fcc_attach
      set forward_decode
      set reply_to
      set reverse_name
      set include
      set forward_quote
      set mime_forward
      set text_flowed
      set sig_on_top
      set move = no

      set quit
      set beep_new
      set pipe_decode
      set thorough_search

      # Colours
      source ${neomutt_gruvbox}/colors-gruvbox-shuber.muttrc
      source ${neomutt_gruvbox}/colors-gruvbox-shuber-extended.muttrc
    '';

    macros = [
      {
        map = [ "index" "pager" ];
        key = "B";
        action = "<view-attachments><search>html<enter><view-mailcap><exit>";
      }
      {
        map = [ "index" ];
        key = "S";
        action = "<shell-escape>systemctl --user start mbsync.service<enter>";
      }
      { # from muttwizard
        map = [ "index" ];
        key = ''\Co'';
        action = ''<enter-command>unset wait_key<enter><shell-escape>read -p 'Enter a search term to find with notmuch: ' x; echo \$x >~/.cache/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat ~/.cache/mutt_terms) | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/ for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern'';
      }
    ];
  };
}


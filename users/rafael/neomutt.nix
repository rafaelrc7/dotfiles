args@{ pkgs, config, ... }:
let neomutt_gruvbox = pkgs.fetchFromGitHub {
                        owner = "shuber2";
                        repo = "mutt-gruvbox";
                        rev = "91853cfee609ecad5d2cb7dce821a7dfe6d780ef";
                        hash = "sha256-TFxVG2kp5IDmkhYuzhprEz2IE28AEMAi/rUHILa7OPU=";
                      };
    email-utils = import ./email-utils.nix args;
    mutt_bgrun = "${email-utils.mutt_bgrun}/mutt_bgrun";
in {
  # https://gist.github.com/Konfekt/9797372146e65a70a44c1e24a35ae0a2
  xdg.configFile."neomutt/mailcap".text = ''
    text/html; ${mutt_bgrun} ${email-utils.qutebrowser-tmp}/bin/qutebrowser-tmp %s; nametemplate=%s.html; test=test -n "$DISPLAY";
    text/html; ${mutt_bgrun} $BROWSER %s; nametemplate=%s.html; test=test -n "$DISPLAY"
    text/html; ${pkgs.lynx}/bin/lynx -assume_charset=%{charset} -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput
  '';

  programs.neomutt = {
    enable = true;

    vimKeys = true;
    sidebar = {
      enable = true;
      shortPath = true;
    };

    sort = "reverse-threads";
    settings = {
      sort_aux = "last-date-received";
      mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";
      forward_format = ''"Fwd: %s"'';
      assumed_charset = "utf-8";
      send_charset = "us-ascii:utf-8";
      query_command = ''"${pkgs.abook}/bin/abook --mutt-query '%s'"'';
    };

    extraConfig = ''
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

      bind editor <Tab> complete-query

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
        action = "<enter-command>unset wait_key<enter><shell-escape>${email-utils.sync-mail}/bin/sync-mail >/dev/null 2>&1 &<enter><enter-command>set wait_key=yes<enter>";
      }
      { # from muttwizard
        map = [ "index" ];
        key = ''\Co'';
        action = ''<enter-command>unset wait_key<enter><shell-escape>read -p 'Enter a search term to find with notmuch: ' x; echo \$x >~/.cache/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat ~/.cache/mutt_terms) | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/ for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern'';
      }
      {
        map = [ "index" "pager" ];
        key = "U";
        action = "<enter-command>unset wait_key<enter><pipe-message> ${pkgs.urlscan}/bin/urlscan<enter><enter-command>set wait_key=yes<enter>";
      }
      {
        map = [ "attach" "compose" ];
        key = "U";
        action = "<enter-command>unset wait_key<enter><pipe-entry> ${pkgs.urlscan}/bin/urlscan<enter><enter-command>set wait_key=yes<enter>";
      }
      {
        map = [ "index" "pager" ];
        key = "a";
        action = "<pipe-message>${pkgs.abook}/bin/abook --add-email-quiet<return>";
      }
    ];
  };
}


args@{ pkgs, config, ... }:
let
  neomutt_gruvbox = pkgs.fetchFromGitHub {
    owner = "shuber2";
    repo = "mutt-gruvbox";
    rev = "91853cfee609ecad5d2cb7dce821a7dfe6d780ef";
    hash = "sha256-TFxVG2kp5IDmkhYuzhprEz2IE28AEMAi/rUHILa7OPU=";
  };
  mutt_dracula = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "mutt";
    rev = "3072ba9aa0af9781c1f9d361e4c8e736c1349ed1";
    hash = "sha256-mn4mGGxt4XG3lm+lBTTQxV73ljBizs+JkHV9qPwfqxg=";
  };
  mutt_catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "neomutt";
    rev = "f6ce83da47cc36d5639b0d54e7f5f63cdaf69f11";
    hash = "sha256-ye16nP2DL4VytDKB+JdMkBXU+Y9Z4dHmY+DsPcR2EG0=";
  };
  email-utils = import ./email-utils.nix args;
  mutt_bgrun = "${email-utils.mutt_bgrun}/mutt_bgrun";
in
{
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

      unset mark_old

      bind editor <Tab> complete-query

      # Colours
      source ${mutt_catppuccin}/neomuttrc
    '';

    macros = [
      {
        map = [ "index" ];
        key = "q";
        action = "<enter-command>unset wait_key<enter><enter-command>exec sync-mailbox<enter><shell-escape>sleep 1 && ${email-utils.sync-mail}/bin/sync-mail<enter><quit>";
      }
      {
        map = [ "index" "pager" ];
        key = "B";
        action = "<view-attachments><search>html<enter><view-mailcap><exit>";
      }
      {
        map = [ "index" ];
        key = "S";
        action = "<enter-command>unset wait_key<enter><enter-command>exec sync-mailbox<enter><shell-escape>sleep 1 && ${email-utils.sync-mail}/bin/sync-mail<enter><enter-command>set wait_key=yes<enter><enter-command>exec sync-mailbox<enter>";
      }
      {
        # from muttwizard
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

  accounts.email.accounts.protonmail = with config.accounts.email.accounts.protonmail; {
    notmuch.neomutt.enable = true;
    neomutt = {
      enable = true;
      extraMailboxes = [ "Starred" "Archive" folders.sent folders.drafts folders.trash "Spam" ];

      extraConfig = ''
        set pgp_default_key = "${gpg.key}"
        set pgp_self_encrypt = yes

        # protonmail-bridge already saves sent email to Sent.
        set copy = no
      '';
    };
  };

  accounts.email.accounts.tecgraf = with config.accounts.email.accounts.tecgraf; {
    notmuch.neomutt.enable = true;
    neomutt.enable = true;
  };

}


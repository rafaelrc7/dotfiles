args@{
  pkgs,
  lib,
  config,
  ...
}:
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
  xdg.configFile."neomutt/mailcap".text =
    let
      soffice = "${pkgs.libreoffice-fresh}/lib/libreoffice/program/soffice --nologo";
      tohtml = lib.getExe (
        pkgs.writeShellApplication {
          name = "tohtml";
          runtimeInputs = with pkgs; [
            pandoc
            w3m
          ];
          text = ''
            pandoc --from="$1" --to=html "$2" | w3m -dump -T text/html -
          '';
        }
      );
      pdftohtml = lib.getExe (
        pkgs.writeShellApplication {
          name = "pdftohtml";
          runtimeInputs = with pkgs; [
            poppler_utils
            w3m
          ];
          text = ''
            pdftotext -nopgbrk -q -htmlmeta -- "$1" - | w3m -dump -T text/html -
          '';
        }
      );
      doctohtml = lib.getExe (
        pkgs.writeShellApplication {
          name = "doctohtml";
          runtimeInputs = with pkgs; [
            wv
            w3m
          ];
          text = ''
            wvHtml "$1" - | w3m -dump -T text/html -
          '';
        }
      );
    in
    ''
      # Text
      text/markdown; ${tohtml} markdown %s; copiousoutput

      application/json; ${lib.getExe pkgs.jq} --color-output . %s; copiousoutput

      text/html; ${mutt_bgrun} ${lib.getExe email-utils.qutebrowser-tmp} %s; nametemplate=%s.html; test=test -n "$DISPLAY"
      text/html; ${mutt_bgrun} $BROWSER %s; nametemplate=%s.html; test=test -n "$DISPLAY"
      text/html; ${lib.getExe pkgs.w3m} -dump -I %{charset} -O utf-8 %s; nametemplate=%s.html; copiousoutput


      # PDFs
      application/pdf; ${mutt_bgrun} ${lib.getExe pkgs.zathura} %s; test=test -n "$DISPLAY"; nametemplate=%s.pdf
      application/pdf; ${pdftohtml} %s; nametemplate=%s.pdf; copiousoutput

      application/x-pdf; ${mutt_bgrun} ${lib.getExe pkgs.zathura} %s; test=test -n "$DISPLAY"; nametemplate=%s.pdf
      application/x-pdf; ${pdftohtml} %s; nametemplate=%s.pdf; copiousoutput


      # Images
      image/*; ${mutt_bgrun} ${lib.getExe pkgs.imv} %s; test=test -n "$DISPLAY"


      # Videos
      video/*; ${mutt_bgrun} ${lib.getExe pkgs.mpv} %s; test=test -n "$DISPLAY"


      # Office Documents
      application/vnd.oasis.opendocument.text; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/vnd.oasis.opendocument.text; ${tohtml} odt %s; copiousoutput

      application/vnd.oasis.opendocument.spreadsheet; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/vnd.oasis.opendocument.presentation; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/vnd.openxmlformats-officedocument.wordprocessingml.document; ${mutt_bgrun} ${soffice} %s; nametemplate=%s.docx; test=test -n "$DISPLAY"
      application/vnd.openxmlformats-officedocument.wordprocessingml.document; ${tohtml} docx %s; nametemplate=%s.docx; copiousoutput
      application/vnd.openxmlformats-officedocument.wordprocessingml.template; ${mutt_bgrun} ${soffice} %s; nametemplate=%s.docm; test=test -n "$DISPLAY"
      application/vnd.openxmlformats-officedocument.wordprocessingml.template; ${tohtml} docx %s; nametemplate=%s.docm; copiousoutput

      application/msword; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/msword; ${doctohtml} %s; copiousoutput

      application/vnd.msword; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/vnd.msword; ${doctohtml} %s; copiousoutput

      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/vnd.openxmlformats-officedocument.spreadsheetml.template; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/vnd.ms-excel; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/csv; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/vnd.openxmlformats-officedocument.presentationml.presentation; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/vnd.openxmlformats-officedocument.presentationml.template; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
      application/vnd.openxmlformats-officedocument.presentationml.slideshow; ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"

      application/vnd.ms-powerpoint ${mutt_bgrun} ${soffice} %s; test=test -n "$DISPLAY"
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
      set abort_key = "<Esc>"

      set abort_noattach = "ask-yes"
      set abort_noattach_regex = "\\<(attach|attached|attachments?|anexos?|anexado)\\>"

      set attach_save_dir = "${config.xdg.userDirs.download}"

      # Colours
      source ${mutt_catppuccin}/neomuttrc

      # Encryption
      set crypt_use_gpgme = yes
      set postpone_encrypt = yes # Necessary for pgp_self_encrypt
      set pgp_self_encrypt = yes
      set crypt_use_pka = no
      set crypt_auto_sign = no
      set crypt_auto_encrypt = no
      set crypt_auto_pgp = yes
    '';

    macros = [
      {
        map = [ "index" ];
        key = "q";
        action = "<enter-command>unset wait_key<enter><enter-command>exec sync-mailbox<enter><shell-escape>sleep 1 && ${lib.getExe email-utils.sync-mail}<enter><quit>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "B";
        action = "<view-attachments><search>html<enter><view-mailcap><exit>";
      }
      {
        map = [ "index" ];
        key = "S";
        action = "<enter-command>unset wait_key<enter><enter-command>exec sync-mailbox<enter><shell-escape>sleep 1 && ${lib.getExe email-utils.sync-mail}<enter><enter-command>set wait_key=yes<enter><enter-command>exec sync-mailbox<enter>";
      }
      {
        # from muttwizard
        map = [ "index" ];
        key = ''\Co'';
        action = ''<enter-command>unset wait_key<enter><shell-escape>read -p 'Enter a search term to find with notmuch: ' x; echo \$x >~/.cache/mutt_terms<enter><limit>~i \"\`notmuch search --output=messages \$(cat ~/.cache/mutt_terms) | head -n 600 | perl -le '@a=<>;s/\^id:// for@a;$,=\"|\";print@a' | perl -le '@a=<>; chomp@a; s/\\+/\\\\+/ for@a;print@a' \`\"<enter>" "show only messages matching a notmuch pattern'';
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "U";
        action = "<enter-command>unset wait_key<enter><pipe-message> ${pkgs.urlscan}/bin/urlscan<enter><enter-command>set wait_key=yes<enter>";
      }
      {
        map = [
          "attach"
          "compose"
        ];
        key = "U";
        action = "<enter-command>unset wait_key<enter><pipe-entry> ${pkgs.urlscan}/bin/urlscan<enter><enter-command>set wait_key=yes<enter>";
      }
      {
        map = [
          "index"
          "pager"
        ];
        key = "a";
        action = "<pipe-message>${pkgs.abook}/bin/abook --add-email-quiet<return>";
      }
    ];
  };
}

{ pkgs, config, ... }: rec {
  # https://unix.stackexchange.com/questions/231184/how-can-i-use-mutt-with-local-storage-imap-and-instant-pushing-of-new-email
  update-new-mail-count = pkgs.writeShellScriptBin "update-new-mail-count" ''
    set -eo pipefail

    mail_account="''${1:?Missing account name argument}"
    inbox_name="''${2:-Inbox}"

    account_maildir="${config.accounts.email.maildirBasePath}"/"$mail_account"
    if [[ ! -d $account_maildir ]]; then
      echo "Missing account folder: $account_maildir"
      exit 1
    fi

    inbox_folder="$account_maildir/$inbox_name"
    if [[ ! -d $inbox_folder ]]; then
      echo "Missing account inbox folder: $inbox_folder"
      exit 1
    fi

    mail_count_directory="${config.xdg.cacheHome}/newmailcount"
    mail_count_file="$mail_count_directory"/"$mail_account"
    [[ ! -d $mail_count_directory ]] && mkdir -p $mail_count_directory

    new_count=$(find "$inbox_folder"/new -type f | wc -l)
    if [[ $new_count > 0 ]]; then
      echo $new_count > "$mail_count_file"
    else
      [[ -f "$mail_count_file" ]] && rm "$mail_count_file"
    fi

    exit 0
  '';

  notify-new-mail = pkgs.writeShellScriptBin "notify-new-mail" ''
    set -eo pipefail

    send-notification () {
      mail_account="''${1:?Missing account name argument}"
      new_mail_counter="${config.xdg.cacheHome}/newmailcount/$mail_account"

      [[ ! -f $new_mail_counter ]] && exit 0

      icon=${pkgs.adwaita-icon-theme}/share/icons/Adwaita/symbolic/status/mail-unread-symbolic.svg
      new_mail_count=`cat "$new_mail_counter"`

      ${pkgs.libnotify}/bin/notify-send --icon="$icon"\
        "You've got mail ($new_mail_count)"\
        "New e-mail arrived in the '$mail_account' account."
    }

    if [[ ! -z $1 ]]; then
      send-notification "$1"
    else
      maildir="${config.accounts.email.maildirBasePath}"
      [[ ! -d $maildir ]] && exit 0

      for account_dir in "$maildir"/*/
      do
        account_name=`basename "$account_dir"`
        send-notification "$account_name"
      done

      exit 0
    fi

    exit 0
  '';

  sync-mail = pkgs.writeShellScriptBin "sync-mail" ''
    set -eo pipefail

    account_name="''${1:--Va}"

    ${pkgs.isync}/bin/mbsync "$account_name"
    ${pkgs.notmuch}/bin/notmuch new

    if [[ ! -z $1 ]]; then
      ${update-new-mail-count}/bin/update-new-mail-count "$account_name"
    else
      maildir="${config.accounts.email.maildirBasePath}"
      [[ ! -d $maildir ]] && exit 0

      for account_dir in "$maildir"/*/
      do
        account_name=`basename "$account_dir"`
        ${update-new-mail-count}/bin/update-new-mail-count "$account_name"
      done
    fi

    exit 0
  '';

  mutt_bgrun = pkgs.fetchFromGitHub {
    owner = "rafaelrc7";
    repo = "mutt_bgrun";
    rev = "c6bc073e50f521414566cec214a5a5ba854dd2c6";
    hash = "sha256-gUROyxImvwIqJpgKqYYDkgtYHS57iuPfqxST21hh4K0=";
  };

  # https://hund.tty1.se/2021/05/22/better-url-management-in-neomutt-with-urlview.html
  qutebrowser-tmp = pkgs.writeShellScriptBin "qutebrowser-tmp" ''
    set -eo pipefail

    PROFILEDIR=`mktemp -p /tmp -d tmp-qb-profile.XXXXXX.d`
    USERPROFILEDIR=`~/.config/qutebrowser/`
    mkdir $PROFILEDIR/config

    if [[ -d $USERPROFILEDIR ]]; then
      [[ -a $USERPROFILEDIR/user-stylecheet.css ]] && cp "$USERPROFILEDIR/user-stylecheet.css" "$PROFILEDIR/config/"
      [[ -a $USERPROFILEDIR/autoconfig.yml ]] && cp "$USERPROFILEDIR/autoconfig.yml" "$PROFILEDIR/config/"
    fi

    if [[ -d ~/.local/share/qutebrowser/userscripts ]]; then
      mkdir $PROFILEDIR/data/userscripts/
      cp ~/.local/share/qutebrowser/userscripts $PROFILEDIR/data/userscripts/
    fi

    ${pkgs.qutebrowser}/bin/qutebrowser --basedir $PROFILEDIR $1
    rm -rf $PROFILEDIR
  '';
}


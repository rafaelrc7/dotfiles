{ pkgs, config, ... }: rec {
  # https://unix.stackexchange.com/questions/231184/how-can-i-use-mutt-with-local-storage-imap-and-instant-pushing-of-new-email
  update-new-mail-count = pkgs.writeShellScriptBin "update-new-mail-count" ''
    set -e

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

    mail_count_directory="${config.home.homeDirectory}/.cache/newmailcount"
    mail_count_file="$mail_count_directory"/"$mail_account"
    [[ ! -d $mail_count_directory ]] && mkdir -p $mail_count_directory

    new_count=$(find "$inbox_folder"/new -type f | wc -l)
    if [[ $new_count > 0 ]]; then
      echo $new_count > "$mail_count_file"
    else
      [[ -f "$mail_count_file" ]] && rm "$mail_count_file"
    fi
  '';

  notify-new-mail = pkgs.writeShellScriptBin "notify-new-mail" ''
    set -e

    send-notification () {
      mail_account="''${1:?Missing account name argument}"
      new_mail_counter="${config.home.homeDirectory}/.cache/newmailcount/$mail_account"

      [[ ! -f $new_mail_counter ]] && exit 0

      icon=${pkgs.gnome.adwaita-icon-theme}/share/icons/Adwaita/symbolic/status/mail-unread-symbolic.svg
      new_mail_count=`cat "$new_mail_counter"`

      ${pkgs.libnotify}/bin/notify-send --icon="$icon"\
        "You've got mail ($new_mail_count)"\
        "New e-mail arrived in the protonmail account."
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
  '';

  sync-mail = pkgs.writeShellScriptBin "sync-mail" ''
    set -e

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
  '';
}


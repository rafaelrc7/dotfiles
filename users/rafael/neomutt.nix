{ pkgs, config, ... }: {
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
    };

    macros = [
      {
        map = [ "index" "pager" ];
        key = "B";
        action = "<view-attachments><search>html<enter><view-mailcap><exit>";
      }
    ];
  };
}


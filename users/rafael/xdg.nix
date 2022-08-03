{ config, ... }: {
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "pcmanfm.desktop" ];
        "x-scheme-handler/https" = [
          "librewolf.desktop"
          "firefox.desktop"
          "chromium-browser.desktop"
        ];
        "application/x-extension-html" = [
          "librewolf.desktop"
          "firefox.desktop"
          "chromium-browser.desktop"
        ];
        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [
          "feh.desktop"
          "firefox.desktop"
          "org.kde.krita.desktop"
        ];
        "application/pdf" = "zathura.desktop";
        "text/*" = "nvim-qt.desktop";
      };
    };
  };
}


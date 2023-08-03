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
        "x-scheme-handler/http" = [
          "librewolf.desktop"
          "firefox.desktop"
          "chromium-browser.desktop"
        ];
        "x-scheme-handler/nxm" = [
          "modorganizer2-nxm-handler.desktop"
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
        "application/pdf" = "org.kde.okular.desktop";
        "text/*" = [
          "nvim.desktop"
          "nvim-qt.desktop"
        ];
      };
    };
  };
}


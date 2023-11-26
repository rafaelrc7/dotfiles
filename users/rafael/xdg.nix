{ config, ... }: {
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [
          "org.kde.dolphin.desktop"
          "pcmanfm.desktop"
        ];
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
        "x-scheme-handler/mw-matlab" = [
          "mw-matlab.desktop"
        ];
        "x-scheme-handler/mw-simulink" = [
          "mw-simulink.desktop"
        ];
        "application/x-extension-html" = [
          "librewolf.desktop"
          "firefox.desktop"
          "chromium-browser.desktop"
        ];
        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [
          "imv.desktop"
          "feh.desktop"
          "firefox.desktop"
          "org.kde.krita.desktop"
        ];
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/*" = [
          "nvim.desktop"
          "nvim-qt.desktop"
        ];
      };
    };
  };
}


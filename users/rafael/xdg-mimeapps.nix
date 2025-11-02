{ ... }:
{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [
        "org.kde.dolphin.desktop"
        "pcmanfm.desktop"
      ];
      "x-scheme-handler/https" = [
        "firefox.desktop"
        "google-chrome.desktop"
        "chromium-browser.desktop"
      ];
      "x-scheme-handler/http" = [
        "firefox.desktop"
        "google-chrome.desktop"
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
      "x-scheme-handler/tg" = [
        "org.telegram.desktop.desktop"
      ];
      "x-scheme-handler/zoommtg=us.zoom.Zoom.desktop" = [
        "us.zoom.Zoom.desktop"
      ];
      "application/x-extension-html" = [
        "firefox.desktop"
        "google-chrome.desktop"
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
      "x-scheme-handler/unityhub" = [
        "unityhub.desktop"
      ];
    };
  };
}

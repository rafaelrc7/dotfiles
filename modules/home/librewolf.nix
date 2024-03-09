{ pkgs, lib, ... }: {
  programs.librewolf = {
    enable = true;
    settings = {
      # Enable DRM
      "media.eme.enabled" = true;
      "media.gmp-widevinecdm.visible" = true;
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-provider.enabled" = true;
      "media.gmp-manager.url" = "https://aus5.mozilla.org/update/3/GMP/%VERSION%/%BUILD_ID%/%BUILD_TARGET%/%LOCALE%/%CHANNEL%/%OS_VERSION%/%DISTRIBUTION%/%DISTRIBUTION_VERSION%/update.xml";

      # Enable hardware acceleration
      "webgl.disabled" = false;
      "webgl.enable-webgl2" = true;
      "media.ffmpeg.vaapi.enabled" = true;

      # Quality of life and tweaks
      "ui.context_menus.after_mouseup" = true; # Keep context menu open
      "browser.compactmode.show" = true; # Make browser bar occupy less space
      "browser.download.start_downloads_in_tmp_dir" = true; # Dont clutter ~/Downloads folder with temporary files
    };
  };

  home.sessionVariables = {
    BROWSER = lib.mkDefault "librewolf";
  };
}


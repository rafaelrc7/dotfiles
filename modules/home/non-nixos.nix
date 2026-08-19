{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf (osConfig == null) {
    targets.genericLinux.enable = true;
    targets.genericLinux.gpu.enable = true;

    systemd.user.packages = lib.optionals (config.xdg.portal.enable) (
      [ pkgs.xdg-desktop-portal ] ++ config.xdg.portal.extraPortals
    );

    home.file.".xprofile".text = ''
      #!/bin/sh
      [ -e "$HOME/.zshenv" ] && . "$HOME/.zshenv"
      [ -e "$HOME/.profile" ] && . "$HOME/.profile"

      # nix flatpak fix for opening links and other non-flatpak default apps
      sh -c "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service" &
    '';

    home.sessionVariables.GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
  };

}

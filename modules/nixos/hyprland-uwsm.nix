{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.uwsm;

  # Helper function to create desktop entry files for UWSM-managed compositors
  mk_uwsm_desktop_entry =
    opts:
    (pkgs.writeTextFile {
      name = "${opts.name}_uwsm";
      text = ''
        [Desktop Entry]
        Name=${opts.prettyName} (UWSM)
        Comment=${opts.comment}
        Exec=${lib.getExe cfg.package} start -e -D ${opts.prettyName} -F ${opts.binPath}
        Type=Application
      '';
      destination = "/share/wayland-sessions/${opts.name}_uwsm.desktop";
      derivationArgs = {
        passthru.providedSessions = [ "${opts.name}_uwsm" ];
      };
    });
in
{
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.uwsm.waylandCompositors.hyprland.binPath =
    lib.mkForce "/run/current-system/sw/bin/start-hyprland";

  # Generate non-botched name
  services.displayManager = {
    enable = true;
    sessionPackages = lib.mapAttrsToList (
      name: value:
      mk_uwsm_desktop_entry {
        inherit name;
        inherit (value) prettyName comment binPath;
      }
    ) cfg.waylandCompositors;
  };
}

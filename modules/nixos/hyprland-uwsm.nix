{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprlandDesktopEntry = (
    pkgs.writeTextFile (
      let
        name = "hyprland";
        hyprlandCfg = config.programs.uwsm.waylandCompositors.${name};
      in
      {
        name = "${name}_uwsm";
        text = ''
          [Desktop Entry]
          Name=${hyprlandCfg.prettyName} (UWSM)
          Comment=${hyprlandCfg.comment}
          Exec=${lib.getExe config.programs.uwsm.package} start -e -D ${hyprlandCfg.prettyName} -F -- ${hyprlandCfg.binPath} ${lib.strings.escapeShellArgs hyprlandCfg.extraArgs}
          Type=Application
        '';
        destination = "/share/wayland-sessions/${name}_uwsm.desktop";
        derivationArgs = {
          passthru.providedSessions = [ "${name}_uwsm" ];
        };
      }
    )
  );
in
{
  programs.uwsm.enable = true;

  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/start-hyprland";
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Generate non-botched name
  services.displayManager.sessionPackages = [ hyprlandDesktopEntry ];
  environment.systemPackages = [ hyprlandDesktopEntry ];
}

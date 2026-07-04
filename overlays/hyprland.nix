inputs: final: prev:
let
  system = final.stdenv.hostPlatform.system;
in
{
  hyprland = inputs.hyprland.packages.${system}.hyprland;
  xdg-desktop-portal-hyprland = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
}

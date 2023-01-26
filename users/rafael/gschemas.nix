{ pkgs, ... }:
let
  gtk3 = pkgs.gtk3;
in {
  home.file.".local/share/glib-2.0/schemas/gschemas.compiled".source =
    "${gtk3}/share/gsettings-schemas/gtk+3-${gtk3.version}/glib-2.0/schemas/gschemas.compiled";
}


inputs: final: prev:
let
  discord = (prev.discord.override { nss = prev.nss_latest; });
in
{
  discord = final.symlinkJoin {
    pname = discord.pname;
    version = discord.version;
    paths = [ discord ];
    buildInputs = [ final.makeWrapper ];
    postBuild = ''
      wrapProgram $out/opt/Discord/Discord \
        --set NIXOS_OZONE_WL ""
    '';
  };
}

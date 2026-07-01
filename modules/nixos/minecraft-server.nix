{ pkgs, ... }:
{
  services.nix-minecraft-servers = {
    enable = true;

    servers.test = {
      enable = true;
      autoStart = false;
      eula = true;
      openFirewall = true;
      server = pkgs.papermc;
    };

    servers.createmodpack = {
      enable = true;
      autoStart = false;
      eula = true;
      openFirewall = true;

      javaPackage = pkgs.jre_headless;
      jvmOpts = [
        "-Djava.net.preferIPv6Addresses=true"
        "-XX:+UseZGC"
      ];
    };
  };

}

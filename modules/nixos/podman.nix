{ pkgs, ... }:
{
  virtualisation.containers = {
    enable = true;
    containersConf.settings.engine = {
      compose_providers = [ "${pkgs.docker-compose}/bin/docker-compose" ];
      compose_warning_logs = false;
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    podman-compose
  ];

  environment.variables = {
    DOCKER_HOST = "unix:///run/user/$UID/podman/podman.sock";
  };
}

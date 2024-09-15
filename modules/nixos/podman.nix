{ pkgs, ... }: {
  virtualisation.containers.enable = true;
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


{ ... }: {
  services.ddclient = {
    enable = true;
    use = "if,";
    configFile = "/etc/ddclient.conf";
  };
}


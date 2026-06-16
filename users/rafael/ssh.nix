{ config, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "aur.archlinux.org" = {
        IdentityFile = "${config.home.homeDirectory}/.ssh/aur";
        User = "aur";
      };

      "hurricane" = {
        User = "desenvolvedor";
      };

      "nxkvm" = {
        Hostname = "192.168.1.240";
        Port = 2222;
        ProxyJump = "hurricane";
        User = "user";
      };
    };

    extraConfig = ''
      XAuthLocation ${pkgs.xauth}/bin/xauth
    '';
  };

}

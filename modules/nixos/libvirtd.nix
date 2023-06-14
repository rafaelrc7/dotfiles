{ pkgs, ... }: {
  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      allowedBridges = [ "br0" ];
      qemu = {
        runAsRoot = false;
        ovmf.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libguestfs
    spice-vdagent
    virt-manager
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
}


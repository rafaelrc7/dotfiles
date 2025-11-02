{ config, pkgs, ... }:
{
  programs.dconf.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "br0" ];
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    libguestfs
    spice-vdagent

    (pkgs.writeShellScriptBin "kvm" ''
      ${config.virtualisation.libvirtd.qemu.package}/bin/qemu-system-${stdenv.hostPlatform.qemuArch} -enable-kvm "$@"
    '')
  ];

  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];
}

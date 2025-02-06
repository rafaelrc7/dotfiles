{ self, ... }:
{
  imports = with self.nixosModules; [
    common
    appimage
    geoclue
    gnupg-agent
    nix
    zsh
    fonts
    man
    ssh
    git
    polkit
    tailscale
    systemd-oomd
    temperature-symlink
  ];
}

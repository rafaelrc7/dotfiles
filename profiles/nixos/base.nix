nixosModules: {
  imports = with nixosModules; [
    common
    appimage
    fonts
    geoclue
    git
    gnupg-agent
    man
    nix
    polkit
    ssh
    systemd-oomd
    tailscale
    temperature-symlink
    zsh
  ];
}

nixosModules: {
  imports = with nixosModules; [
    appimage
    common
    fonts
    geoclue
    git
    gnupg-agent
    keychron
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

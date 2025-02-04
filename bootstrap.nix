# https://github.com/Misterio77/nix-starter-configs/blob/0537107ce41396dff1fb1dd43705a94e9120f576/standard/shell.nix

# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  system ? "x86_64-linux",
  pkgs ? (import ./nixpkgs.nix) { inherit system; },
}:
pkgs.mkShell {
  # Enable experimental features without having to specify the argument
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    git
    home-manager
    neovim
    nh
    nixVersions.latest
  ];
}

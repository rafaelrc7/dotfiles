{ pkgs, ... }:
{
  home.packages = with pkgs; [
    monero-cli
    p2pool
    wasabiwallet
    bisq2
    bisq-desktop
    monero-gui
  ];
}

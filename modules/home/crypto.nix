{ pkgs, ... }:
{
  home.packages = with pkgs; [
    monero-cli
    p2pool
    wasabiwallet
    bisq-desktop
    bisq2
    monero-gui
  ];
}

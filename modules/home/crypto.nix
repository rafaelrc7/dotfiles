{ pkgs, ... }:
{
  home.packages = with pkgs; [
    monero-cli
    p2pool
    wasabiwallet
    bisq2
    monero-gui
  ];
}

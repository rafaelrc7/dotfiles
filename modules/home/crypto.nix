{ pkgs, ... }:
{
  home.packages = with pkgs; [
    monero-cli
    p2pool
    wasabiwallet
    bisq1
    monero-gui
  ];
}

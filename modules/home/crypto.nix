{ pkgs, ... }:
{
  home.packages = with pkgs; [
    monero-cli
    p2pool
    bisq1
    monero-gui
  ];
}

{ pkgs, ... }: {

  home.packages = with pkgs; [
    monero-cli
    p2pool
    wasabiwallet
    nixpkgs-master.bisq-desktop
    nixpkgs-master.monero-gui
  ];

}


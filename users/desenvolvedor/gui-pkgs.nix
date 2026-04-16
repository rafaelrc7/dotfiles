{ pkgs, ... }:
{
  home.packages = with pkgs; [
    crosspipe
    gimp
    obsidian
    pwvucontrol
    qalculate-qt
    qutebrowser
    spotify
    thunderbird
  ];
}

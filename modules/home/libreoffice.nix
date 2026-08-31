{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice

    hunspell

    hunspellDicts.de_DE
    hunspellDicts.en_GB-ise
    hunspellDicts.en_US
    hunspellDicts.pt_BR

    hyphenDicts.de_DE
    hyphenDicts.en_GB
    hyphenDicts.en_US
    hyphenDicts.pt_BR
  ];
}

{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      vscodevim.vim

      eamodio.gitlens

      editorconfig.editorconfig

      ms-azuretools.vscode-docker

      angular.ng-template
      ecmel.vscode-html-css
      firefox-devtools.vscode-firefox-debug

      #visualstudioexptteam.vscodeintellicode
      redhat.java
      vscjava.vscode-java-debug
      vscjava.vscode-maven
      vscjava.vscode-java-test
      vscjava.vscode-java-dependency
      vscjava.vscode-gradle
      vscjava.vscode-spring-initializr

      fwcd.kotlin

      ms-vscode.cpptools
      #ms-vscode.cmake-tools

      #vsciot-vscode.vscode-arduino
    ];
  };
}


{ inputs, pkgs, ... }: {
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
      ms-vscode-remote.remote-containers

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

      ms-vscode.cpptools-extension-pack
      ms-vscode.cpptools
      ms-vscode.cpptools-themes
      (ms-vscode.makefile-tools.overrideAttrs (_: { sourceRoot = "extension"; }))
      (ms-vscode.cmake-tools.overrideAttrs (_: { sourceRoot = "extension"; }))
      twxs.cmake
      dtoplak.vscode-glsllint slevesque.shader

      #vsciot-vscode.vscode-arduino

      maximedenes.vscoq
    ];
    userSettings = {
      vscoq.path = "${pkgs.coqPackages.vscoq-language-server}/bin/vscoqtop";
    };
  };
}


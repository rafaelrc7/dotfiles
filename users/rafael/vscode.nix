{ inputs, config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-marketplace; [
      vscodevim.vim

      eamodio.gitlens

      editorconfig.editorconfig

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

      slevesque.shader
      dtoplak.vscode-glsllint

      (vsciot-vscode.vscode-arduino.overrideAttrs (_: { sourceRoot = "extension"; }))
      (ms-vscode.vscode-serial-monitor.overrideAttrs (_: { sourceRoot = "extension"; }))
      platformio.platformio-ide

      pinage404.nix-extension-pack
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      mkhl.direnv

      maximedenes.vscoq

      ms-azuretools.vscode-docker
      ms-vscode-remote.vscode-remote-extensionpack
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-wsl
      ms-vscode-remote.remote-ssh
      ms-vscode.remote-server

      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    userSettings = {
      vscoq.path = "${pkgs.coqPackages.vscoq-language-server}/bin/vscoqtop";
      git.openRepositoryInParentFolders = "never";
      vim = {
        useSystemClipboard = true;
      };
      makefile.configureOnOpen = true;

      catppuccin.accentColor = "blue";
      workbench.colorTheme = "Catppuccin Mocha";
      workbench.iconTheme = "catppuccin-mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
    };

    keybindings = [
      {
        key = "tab";
        command = "selectNextSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "shift+tab";
        command = "selectPrevSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "enter";
        command = "acceptAlternativeSelectedSuggestion";
        when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
    ];
  };

  home.file.".platformio/penv/pyvenv.cfg".text = ''
    home = ${pkgs.python3}/bin
    include-system-site-packages = false
    version = ${pkgs.python3.version}
    executable = ${pkgs.python3}/bin/python
    command = ${pkgs.python3}/bin/python -m venv /home/rafael/.platformio/penv
  '';
}


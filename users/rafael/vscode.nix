{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    extensions =
      let
        vscode-marketplace = pkgs.vscode-marketplace;
        vscode-extensions = pkgs.vscode-extensions;
      in
      [
        vscode-extensions.vscodevim.vim

        vscode-extensions.eamodio.gitlens

        vscode-extensions.editorconfig.editorconfig

        vscode-extensions.angular.ng-template
        vscode-extensions.ecmel.vscode-html-css
        vscode-extensions.firefox-devtools.vscode-firefox-debug

        vscode-extensions.redhat.java
        vscode-extensions.vscjava.vscode-java-debug
        vscode-extensions.vscjava.vscode-maven
        vscode-extensions.vscjava.vscode-java-test
        vscode-extensions.vscjava.vscode-java-dependency
        vscode-extensions.vscjava.vscode-gradle
        vscode-extensions.vscjava.vscode-spring-initializr

        vscode-marketplace.fwcd.kotlin

        vscode-extensions.ms-vscode.cpptools-extension-pack
        vscode-extensions.ms-vscode.cpptools
        vscode-extensions.ms-vscode.makefile-tools
        vscode-extensions.ms-vscode.cmake-tools
        vscode-extensions.twxs.cmake

        vscode-marketplace.slevesque.shader
        vscode-marketplace.dtoplak.vscode-glsllint

        (vscode-marketplace.vsciot-vscode.vscode-arduino.overrideAttrs (_: {
          sourceRoot = "extension";
        }))
        (vscode-marketplace.ms-vscode.vscode-serial-monitor.overrideAttrs (_: {
          sourceRoot = "extension";
        }))
        vscode-marketplace.platformio.platformio-ide

        vscode-marketplace.pinage404.nix-extension-pack
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.arrterian.nix-env-selector
        vscode-extensions.mkhl.direnv

        vscode-extensions.maximedenes.vscoq

        vscode-extensions.ms-azuretools.vscode-docker
        vscode-marketplace.ms-vscode-remote.vscode-remote-extensionpack
        vscode-extensions.ms-vscode-remote.remote-containers
        vscode-extensions.ms-vscode-remote.remote-wsl
        vscode-extensions.ms-vscode-remote.remote-ssh
        vscode-marketplace.ms-vscode.remote-server

        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.catppuccin.catppuccin-vsc-icons
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

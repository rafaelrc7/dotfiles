{ lib, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-lua
        fcitx5-table-other
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Group 1";
            "Default Layout" = "us-intl";
            "DefaultIM" = "keyboard-us-intl";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us-intl";
          };
          "Groups/0/Items/1" = {
            Name = "ipa-x-sampa";
          };
          "Groups/0/Items/2" = {
            Name = "latex";
          };
          GroupOrder = {
            "0" = "Group 1";
          };
        };
        globalOptions = {
          Hotkey = {
            # Enumerate when press trigger key repeatedly
            EnumerateWithTriggerKeys = true;
            # Skip first input method while enumerating
            EnumerateSkipFirst = false;
            # Time limit in milliseconds for triggering modifier key shortcuts
            ModifierOnlyKeyTimeout = 250;
          };

          "Hotkey/TriggerKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };

          Behavior = {
            # Active By Default
            ActiveByDefault = false;
            # Reset state on Focus In
            resetStateWhenFocusIn = "No";
            # Share Input State
            ShareInputState = "All";
            # Show preedit in application
            PreeditEnabledByDefault = true;
            # Show Input Method Information when switch input method
            ShowInputMethodInformation = true;
            # Show Input Method Information when changing focus
            showInputMethodInformationWhenFocusIn = false;
            # Show compact input method information
            CompactInputMethodInformation = true;
            # Show first input method information
            ShowFirstInputMethodInformation = true;
            # Default page size
            DefaultPageSize = 5;
            # Override Xkb Option
            OverrideXkbOption = false;
            # Preload input method to be used by default
            PreloadInputMethod = true;
            # Allow input method in the password field
            AllowInputMethodForPassword = false;
            # Show preedit text when typing password
            ShowPreeditForPassword = false;
            # Interval of saving user data in minutes
            AutoSavePeriod = 30;
          };

        };
        addons = {
          classicui = {
            globalSection = {
              # Vertical Candidate List
              "Vertical Candidate List" = true;
              # Use mouse wheel to go to prev or next page
              WheelForPaging = true;
              # Font
              Font = "DejaVu Sans 10";
              # Menu Font
              MenuFont = "DejaVu Sans 10";
              # Tray Font
              TrayFont = "DejaVu Sans Bold 10";
              # Tray Label Outline Color
              TrayOutlineColor = "#000000";
              # Tray Label Text Color
              TrayTextColor = "#ffffff";
              # Prefer Text Icon
              PreferTextIcon = false;
              # Show Layout Name In Icon
              ShowLayoutNameInIcon = true;
              # Use input method language to display text
              UseInputMethodLanguageToDisplayText = true;
              # Theme
              Theme = lib.mkDefault "default";
              # Dark Theme
              DarkTheme = "default-dark";
              # Follow system light/dark color scheme
              UseDarkTheme = false;
              # Follow system accent color if it is supported by theme and desktop
              UseAccentColor = true;
              # Use Per Screen DPI on X11
              PerScreenDPI = false;
              # Force font DPI on Wayland
              ForceWaylandDPI = 0;
              # Enable fractional scale under Wayland
              EnableFractionalScale = true;
            };
          };
          clipboard = {
            globalSection = {
              # Number of entries
              "Number of entries" = 5;
              # Do not show password from password managers
              IgnorePasswordFromPasswordManager = true;
              # Display passwords as plain text
              ShowPassword = false;
              # Seconds before clearing password
              ClearPasswordAfter = 30;
            };
            sections = {
              TriggerKey = {
                "0" = "Control+semicolon";
              };
            };
          };
          imselector = {
            globalSection = { };
            sections = {
              TriggerKey = {
                "0" = "Super+period";
              };
            };
          };
          keyboard = {
            globalSection = {
              # Page size
              PageSize = 5;
              # Enable emoji in hint
              EnableEmoji = true;
              # Enable emoji in quickphrase
              EnableQuickPhraseEmoji = true;
              # Choose key modifier
              "Choose Modifier" = "Alt";
              # Enable hint by default
              EnableHintByDefault = false;
              # Use new compose behavior
              UseNewComposeBehavior = true;
              # Type special characters with long press
              EnableLongPress = false;
            };
            sections = {
              PrevCandidate = {
                "0" = "Shift+Tab";
              };
              NextCandidate = {
                "0" = "Tab";
              };
              "Hint Trigger" = {
                "0" = "Control+Alt+H";
              };
              "One Time Hint Trigger" = {
                "0" = "Control+Alt+J";
              };
              LongPressBlocklist = {
                "0" = "konsole";
                "1" = "org.kde.konsole";
              };
            };
          };
          quickphrase = {
            globalSection = {
              "Choose Modifier" = "None";
              Spell = true;
              FallbackSpellLanguage = "en";
            };
            sections = {
              TriggerKey = {
                "0" = "Super+semicolon";
              };
            };
          };
          unicode = {
            globalSection = { };
            sections = {
              TriggerKey = {
                "0" = "Control+Alt+Shift+U";
              };
              DirectUnicodeMode = {
                "0" = "Control+Shift+U";
              };
            };
          };
        };
      };
    };
  };
}

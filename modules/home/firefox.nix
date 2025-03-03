{ lib, pkgs, ... }:
{
  home.sessionVariables = {
    BROWSER = lib.mkDefault "firefox";
  };

  home.packages = with pkgs; [
    ffmpeg
  ];

  programs.firefox = rec {
    enable = true;
    languagePacks = [
      "en-GB"
      "en"
      "pt-BR"
    ];
    nativeMessagingHosts = [

    ];
    policies = {
      AppAutoUpdate = false;
      ContentAnalysis = {
        Enabled = false;
      };
      Cookies = rec {
        Behavior = "reject-foreign";
        BehaviorPrivateBrowsing = Behavior;
      };
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "newtab";
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://family.dns.mullvad.net/dns-query";
        Fallback = false;
      };
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
      };
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      HardwareAcceleration = true;
      HttpsOnlyMode = "enabled";
      NetworkPrediction = false;
      NewTabPage = false;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        History = true;
        Sessions = true;
        SiteSettings = true;
      };
      SearchSuggestEnabled = false;
      StartDownloadsInTempDirectory = true;
    };
    profiles = {
      personal = {
        isDefault = true;
        settings = {
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.useDownloadDir" = false;
          "browser.compactmode.show" = true;
          "browser.tabs.warnOnClose" = true;
          "browser.urlbar.suggest.recentsearches" = false;
          "intl.locale.requested" = builtins.concatStringsSep "," languagePacks;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.resistFingerprinting.letterboxing" = true;

          # Enable hardware acceleration
          "webgl.disabled" = false;
          "webgl.enable-webgl2" = true;
          "media.ffmpeg.vaapi.enabled" = true;
        };
        search = rec {
          default = "DuckDuckGo";
          privateDefault = default;
          force = true;
          engines = {
            "Bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;

            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              definedAliases = [ "@np" ];
            };

            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/w/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@nw" ];
            };

            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "release";
                      value = "master";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@hm" ];
            };

            "Hoogle" = {
              urls = [
                {
                  template = "https://hoogle.haskell.org";
                  params = [
                    {
                      name = "hoogle";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@hs" ];
            };

            "Hoogle GHC" = {
              urls = [
                {
                  template = "https://hoogle.haskell.org/";
                  params = [
                    {
                      name = "scope";
                      value = "set:included-with-ghc";
                    }
                    {
                      name = "hoogle";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@ghc" ];
            };

            "Rust" = {
              urls = [
                {
                  template = "https://doc.rust-lang.org/std/";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = [ "@rs" ];
            };
          };
        };
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            canvasblocker
            clearurls
            consent-o-matic
            cookie-autodelete
            darkreader
            export-cookies-txt
            fastforwardteam
            ff2mpv
            firefox-color
            localcdn
            multi-account-containers
            passff
            privacy-badger
            privacy-settings
            redirector
            return-youtube-dislikes
            search-by-image
            simplelogin
            smart-referer
            sponsorblock
            stylus
            tampermonkey
            temporary-containers
            terms-of-service-didnt-read
            ublock-origin
            xbrowsersync
          ];
        };
      };
    };
  };
}

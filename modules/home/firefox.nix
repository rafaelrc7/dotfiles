{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    BROWSER = lib.mkDefault "firefox";
  };

  home.packages = with pkgs; [
    ffmpeg
  ];

  programs.firefox = rec {
    enable = true;

    configPath = "${config.xdg.configHome}/mozilla/firefox";

    package = pkgs.firefox.overrideAttrs (oldAttrs: {
      makeWrapperArgs = oldAttrs.makeWrapperArgs ++ [
        "--set"
        "MOZ_DISABLE_RDD_SANDBOX"
        "1"

        "--set"
        "CUDA_DISABLE_PERF_BOOST"
        "1"
      ];
    });

    languagePacks = [
      "en-GB"
      "en"
      "pt-BR"
    ];

    nativeMessagingHosts = [

    ];

    policies = {
      AIChatbot.Default = "ChatGPT";

      AppAutoUpdate = false;

      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;

      BackgroundAppUpdate = false;

      ClearOnShutdown = {
        BrowsingHistoryAndDownloads = true;
        CookiesAndStorage = true;
        Cache = true;
        FormData = true;
        SiteSettings = false;

        Exceptions = [
          "https://chatgpt.com"
          "https://kagi.com"
          "https://web.whatsapp.com"
          "https://www.instagram.com/"

          "https://accounts.google.com"
          "https://www.google.com"
          "https://www.youtube.com"
        ];
      };

      Cookies = rec {
        Behavior = "partition-foreign";
        BehaviorPrivateBrowsing = Behavior;
      };

      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisableLaunchOnLogin = true;
      DisableTelemetry = true;

      DisplayBookmarksToolbar = "newtab";

      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.quad9.net/dns-query"; # Quad9
        Fallback = false;
      };

      DontCheckDefaultBrowser = true;

      EnableTrackingProtection = {
        Value = true;
        Category = "strict";
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        SuspectedFingerprinting = true;
        BaselineExceptions = true;
        ConvenienceExceptions = true;
      };

      EncryptedMediaExtensions.Enabled = true;

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Stories = false;
        SponsoredStories = false;
        Weather = true;
        Widgets.Enabled = true;
      };

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        OnlineEnabled = false;
      };

      GoToIntranetSiteForSingleWordEntryInAddressBar = true;

      HardwareAcceleration = true;

      HttpsOnlyMode = "enabled";

      LocalNetworkAccess = {
        Enabled = true;
        BlockTrackers = true;
        EnablePrompting = true;
      };

      NetworkPrediction = false;

      NoDefaultBookmarks = true;

      OfferToSaveLoginsDefault = false;

      PDFjs = {
        Enabled = true;
        EnablePermissions = false;
      };

      PromptForDownloadLocation = true;

      RequestedLocales = languagePacks;

      SearchBar = "unified";

      SearchSuggestEnabled = false;

      ShowHomeButton = true;

      SkipTermsOfUse = true;

      StartDownloadsInTempDirectory = true;
    };
    profiles = {
      personal = {
        isDefault = true;
        # https://github.com/arkenfox/user.js/blob/master/user.js
        settings = {
          "browser.aboutConfig.showWarning" = false;

          "geo.provider.use_geoclue" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;

          # Disable Telemetry
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.opt-out" = true;
          "toolkit.coverage.endpoint.base" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;

          # Disable Studies
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";

          # Disable Crash Reports
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

          "network.connectivity-service.enabled" = false;

          "network.prefetch-next" = false;
          "network.http.speculative-parallel-limit" = 0;
          "browser.places.speculativeConnect.enabled" = false;

          "network.proxy.socks_remote_dns" = true;
          "network.file.disable_unc_paths" = true;

          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.trending.featureGate" = false;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.mdn.featureGate" = false;
          "browser.urlbar.weather.featureGate" = false;
          "browser.urlbar.yelp.featureGate" = false;
          "browser.urlbar.clipboard.featureGate" = false;
          "browser.urlbar.recentsearches.featureGate" = false;
          "browser.urlbar.suggest.engines" = false;

          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;
          "network.auth.subresource-http-auth-allow" = 1;

          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "media.memory_cache_max_size" = 65536;
          "browser.sessionstore.privacy_level" = 2;

          "security.ssl.require_safe_negotiation" = true;
          "security.tls.enable_0rtt_data" = false;

          "security.cert_pinning.enforcement_level" = 2;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "media.peerconnection.ice.default_address_only" = true;
          "dom.disable_window_move_resize" = true;

          "network.IDN_show_punycode" = true;

          "pdfjs.enableScripting" = false;
          "browser.tabs.searchclipboardfor.middleclick" = false;

          "extensions.enabledScopes" = 5;
          "extensions.postDownloadThirdPartyPrompt" = false;

          "browser.compactmode.show" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.tabs.warnOnClose" = true;
          "browser.urlbar.suggest.recentsearches" = false;
          "privacy.globalprivacycontrol.enabled" = true;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

          "privacy.spoof_english" = 1;
          "widget.non-native-theme.use-theme-accent" = false;
          "privacy.antitracking.isolateContentScriptResources" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;

          "browser.helperApps.deleteTempFileOnExit" = true;
          "browser.uitour.enabled" = false;

          # Enable hardware acceleration
          "webgl.disabled" = false;
          "webgl.enable-webgl2" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
        };

        search = rec {
          default = "ddg";
          privateDefault = default;
          force = true;

          engines = {
            bing.metaData.hidden = true;
            ebay.metaData.hidden = true;
            ebay-uk.metaData.hidden = true;
            perplexity.metaData.hidden = true;

            wiktionary = {
              name = "Wiktionary";
              urls = [
                {
                  template = "https://en.wiktionary.org/w/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://en.wiktionary.org/favicon.ico";
              definedAliases = [ "@wiktionary" ];
            };

            youtube = {
              name = "YouTube";
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://www.youtube.com/favicon.ico";
              definedAliases = [ "@yt" ];
            };

            nix-packages = {
              name = "Nix Packages";
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
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            nixos-options = {
              name = "NixOS Options";
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
                      value = "options";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            home-manager-options = {
              name = "Nix home-manager Options";
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
                      value = "options";
                    }
                    {
                      name = "source";
                      value = "home_manager";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };

            nixos-wiki = {
              name = "NixOS Wiki";
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
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };

            noogle = {
              name = "Noogle";
              urls = [
                {
                  template = "https://noogle.dev/q/";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@ng" ];
            };

            hoogle = {
              name = "Hoogle";
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
              iconMapObj."16" = "https://hoogle.haskell.org/favicon.png";
              definedAliases = [ "@hs" ];
            };

            hoogle-ghc = {
              name = "Hoogle GHC";
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
              iconMapObj."16" = "https://hoogle.haskell.org/favicon.png";
              definedAliases = [ "@ghc" ];
            };

            rust = {
              name = "Rust";
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
              iconMapObj."32" = "https://rust-lang.org/static/images/favicon.svg";
              definedAliases = [ "@rs" ];
            };

            proton-db = {
              name = "ProtonDB";
              urls = [
                {
                  template = "https://www.protondb.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."32" = "https://www.protondb.com/favicon.ico";
              definedAliases = [ "@pdb" ];
            };
          };
        };

        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            angular-devtools
            clearurls
            consent-o-matic
            cookie-autodelete
            darkreader
            duckduckgo-privacy-essentials
            export-cookies-txt
            fastforwardteam
            ff2mpv
            firefox-color
            firenvim
            localcdn
            multi-account-containers
            passff
            redirector
            return-youtube-dislikes
            search-by-image
            smart-referer
            sponsorblock
            stylus
            tampermonkey
            temporary-containers
            # terms-of-service-didnt-read
            ublock-origin
            youtube-no-translation
          ];
        };
      };
    };
  };
}

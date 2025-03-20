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
        # https://github.com/arkenfox/user.js/blob/master/user.js
        settings = {
          "browser.aboutConfig.showWarning" = false;

          "geo.provider.use_geoclue" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.shopping.experience2023.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;

          # Disable Telemetry
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
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
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

          "network.connectivity-service.enabled" = false;

          "network.prefetch-next" = false;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.predictor.enabled" = false;
          "network.predictor.enable-prefetch" = false;
          "network.http.speculative-parallel-limit" = 0;
          "browser.places.speculativeConnect.enabled" = false;

          "network.proxy.socks_remote_dns" = true;
          "network.file.disable_unc_paths" = true;
          "network.gio.supported-protocols" = "";

          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.trending.featureGate" = false;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.fakespot.featureGate" = false;
          "browser.urlbar.mdn.featureGate" = false;
          "browser.urlbar.pocket.featureGate" = false;
          "browser.urlbar.weather.featureGate" = false;
          "browser.urlbar.yelp.featureGate" = false;
          "browser.urlbar.clipboard.featureGate" = false;
          "browser.urlbar.recentsearches.featureGate" = false;
          "browser.formfill.enable" = false;
          "browser.urlbar.suggest.engines" = false;

          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;
          "network.auth.subresource-http-auth-allow" = 1;

          "browser.cache.disk.enable" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "media.memory_cache_max_size" = 65536;
          "browser.sessionstore.privacy_level" = 2;
          "toolkit.winRegisterApplicationRestart" = false;
          "browser.shell.shortcutFavicons" = false;

          "security.ssl.require_safe_negotiation" = true;
          "security.tls.enable_0rtt_data" = false;

          "security.OCSP.enabled" = 1;
          "security.OCSP.require" = true;
          "security.cert_pinning.enforcement_level" = 2;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.pki.crlite_mode" = 2;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "media.peerconnection.ice.default_address_only" = true;
          "dom.disable_window_move_resize" = true;

          "network.IDN_show_punycode" = true;

          "pdfjs.disabled" = false;
          "pdfjs.enableScripting" = false;
          "browser.tabs.searchclipboardfor.middleclick" = false;
          "browser.contentanalysis.enabled" = false;
          "browser.contentanalysis.default_result" = 0;

          "extensions.enabledScopes" = 5;
          "extensions.postDownloadThirdPartyPrompt" = false;

          "browser.compactmode.show" = true;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.useDownloadDir" = false;
          "browser.tabs.warnOnClose" = true;
          "browser.urlbar.suggest.recentsearches" = false;
          "intl.locale.requested" = builtins.concatStringsSep "," languagePacks;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.resistFingerprinting.letterboxing" = true;
          "privacy.resistFingerprinting" = true;

          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.clearSiteData.cache" = true;
          "privacy.clearSiteData.cookiesAndStorage" = false;
          "privacy.clearSiteData.historyFormDataAndDownloads" = true;
          "privacy.cpd.cache" = true;
          "privacy.clearHistory.cache" = true;
          "privacy.cpd.formdata" = true;
          "privacy.cpd.history" = true;
          "privacy.clearHistory.historyFormDataAndDownloads" = true;
          "privacy.cpd.cookies" = false;
          "privacy.cpd.sessions" = true;
          "privacy.cpd.offlineApps" = false;
          "privacy.clearHistory.cookiesAndStorage" = false;
          "privacy.sanitize.timeSpan" = 0;

          "privacy.spoof_english" = 1;
          "browser.display.use_system_colors" = false;
          "widget.non-native-theme.use-theme-accent" = false;

          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.helperApps.deleteTempFileOnExit" = true;
          "browser.uitour.enabled" = false;

          # Enable hardware acceleration
          "webgl.disabled" = false;
          "webgl.enable-webgl2" = true;
          "media.ffmpeg.vaapi.enabled" = true;
        };
        search = rec {
          default = "ddg";
          privateDefault = default;
          force = true;
          engines = {
            "bing".metaData.hidden = true;
            "ebay".metaData.hidden = true;

            "Wiktionary" = {
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
              definedAliases = [ "@wiktionary" ];
            };

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
          ];
        };
      };
    };
  };
}

{ lib, ... }: {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [

    ];
    policies = {
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      HardwareAcceleration = true;
      NetworkPrediction = false;
      OfferToSaveLogins = false;
    };
  };

  home.sessionVariables = {
    BROWSER = lib.mkDefault "firefox";
  };

}


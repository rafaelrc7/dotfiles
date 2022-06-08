{ pkgs, ... }: {
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_KEY = "03F104A08E5D7DFE";
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
}


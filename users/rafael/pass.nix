{ pkgs, ... }: {
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_KEY = "081F97AC49F2CA9548DB08E7091BB8A361C7B4EB";
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
}


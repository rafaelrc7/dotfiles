{ pkgs, ... }: {
  home.packages = with pkgs; [ uwsm ];
  systemd.user.packages = with pkgs; [ uwsm ];
}

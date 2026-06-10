{ pkgs, ... }:
{
  services.ollama.enable = true;
  environment.systemPackages = with pkgs; [
    lmstudio
  ];
}

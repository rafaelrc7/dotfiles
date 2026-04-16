homeModules:
(import ./pc.nix homeModules)
++ (with homeModules; [
  crypto
  protonmail-bridge
  rclone-gdrive
  udiskie
])

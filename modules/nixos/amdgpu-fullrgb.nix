{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  kernel = config.boot.kernelPackages.kernel;

  amdgpu_module = pkgs.stdenv.mkDerivation {
    pname = "amdgpu-kernel-module";
    inherit (kernel)
      src
      version
      postPatch
      nativeBuildInputs
      ;

    kernel_dev = kernel.dev;
    kernelVersion = kernel.modDirVersion;

    modulePath = "drivers/gpu/drm/amd/amdgpu";

    buildPhase = ''
      BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

      cp $BUILT_KERNEL/Module.symvers .
      cp $BUILT_KERNEL/.config        .
      cp $kernel_dev/vmlinux          .

      make "-j$NIX_BUILD_CORES" modules_prepare
      make "-j$NIX_BUILD_CORES" M=$modulePath modules
    '';

    installPhase = ''
      make \
        INSTALL_MOD_PATH="$out" \
        XZ="xz -T$NIX_BUILD_CORES" \
        M="$modulePath" \
        modules_install
    '';

    patches = kernel.patches ++ [
      "${inputs.amdgpu-fullrgb-patch}/FullRGB.patch"
    ];

    meta = {
      description = "AMD GPU kernel module";
      license = lib.licenses.gpl3;
    };
  };
in
{
  boot.extraModulePackages = [ amdgpu_module ];
  boot.kernelParams = [
    "amdgpu.pixel_encoding=rgb"
  ];
}

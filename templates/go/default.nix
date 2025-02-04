{
  lib,
  buildGoModule,
}:
buildGoModule {
  pname = "hello";
  version = "0.1.0";
  src = lib.cleanSource ./.;

  # Go uses the internet for downloading deps, thus you need to manually update
  # the vendorHash when they change. You can set it to `lib.fakeHash` and get
  # the right one from the error message
  vendorHash = null;
}

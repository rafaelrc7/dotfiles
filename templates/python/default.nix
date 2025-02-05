{
  lib,
  buildPythonPackage,
  setuptools,
  flask,
}:
buildPythonPackage {
  pname = "hello";
  version = "0.1.0";
  src = lib.cleanSource ./.;

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
  ];
}

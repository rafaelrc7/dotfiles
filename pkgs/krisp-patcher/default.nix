{ stdenv
, python3
}:
stdenv.mkDerivation {
  name = "krisp-patcher";
  installPhase = "install -Dm755 ${./krisp-patcher.py} $out/bin/krisp-patcher";
  dontUnpack = true;
  propagatedBuildInputs = [
    (python3.withPackages (pythonPackages: with pythonPackages; [
      capstone pyelftools
    ]))
  ];
}


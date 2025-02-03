{ inputs, ... }:
final: prev: {
  coqPackages.vscoq-language-server = (
    inputs.vscoq.packages."${final.system}".default.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ prev.coq_8_19 ];
    })
  );
}

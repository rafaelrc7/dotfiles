{
  pkgs ? import <nixpkgs> { },
  haskellPackages ? (import <nixpkgs> { }).haskellPackages,
  devTools ? true,
}:
let
  haskell = haskellPackages.extend (final: prev: { hello = pkgs.callPackage ./default.nix { }; });
in
haskell.shellFor {
  packages = p: [ p.hello ];
  nativeBuildInputs = [
    (haskell.ghc.withPackages (p: [
      haskell.cabal-install
    ]))
  ]
  ++ pkgs.lib.optionals devTools [
    (haskell.ghc.withPackages (p: [
      p.ghci-dap
      p.haskell-dap
      p.haskell-debug-adapter
      p.haskell-language-server
      p.hlint
      p.stylish-haskell
    ]))
  ];
}

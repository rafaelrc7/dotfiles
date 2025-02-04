{ ... }:
{
  go = {
    path = ./go;
    description = "A simple go project using flake-parts";
  };
  haskell = {
    path = ./haskell;
    description = "A simple haskell project using flake-parts";
  };
  rust = {
    path = ./rust;
    description = "A simple rust project using flake-parts";
  };
}

{ inputs, ... }:
final: prev:
let
  remote-nvim = prev.vimUtils.buildVimPlugin {
    name = "remote-nvim";
    src = inputs.remote-nvim;
  };
in
{
  vimPlugins = prev.vimPlugins // {
    inherit remote-nvim;
  };
}

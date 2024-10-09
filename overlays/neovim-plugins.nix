{ inputs, ... }:
final: prev:
let
  remote-nvim = prev.vimUtils.buildVimPlugin {
    name = "remote-nvim";
    src = inputs.remote-nvim;
  };
  markview-nvim = prev.vimUtils.buildVimPlugin {
    name = "markview-nvim";
    src = inputs.markview-nvim;
  };
in
{
  vimPlugins = prev.vimPlugins // {
    inherit remote-nvim markview-nvim;
  };
}


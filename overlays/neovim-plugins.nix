{ inputs, ... }:
final: prev:
let
  remote-nvim = prev.vimUtils.buildVimPlugin {
    name = "remote-nvim";
    src = inputs.remote-nvim;
  };

  lsp-progress-nvim = prev.vimUtils.buildVimPlugin {
    name = "lsp-progress.nvim";
    src = inputs.lsp-progress-nvim;
  };

  trouble-nvim = prev.vimPlugins.trouble-nvim.overrideAttrs (old: {
    src = inputs.trouble-nvim;
  });
in
{
  vimPlugins = prev.vimPlugins // {
    inherit remote-nvim lsp-progress-nvim trouble-nvim;
  };
}


{ lib, ... }:
lib.mkMerge [
  # Core settings
  {
    vim.theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      # transparent = true;
    };
    vim.ui.borders.enable = true;
    vim.opts.tabstop = 2;
    vim.opts.shiftwidth = 2;

    vim.statusline.lualine.enable = true;
    vim.telescope.enable = true;
    vim.autocomplete.nvim-cmp.enable = true;
    vim.visuals.fidget-nvim.enable = true;


    vim.binds.whichKey.enable = true;
  }
  # Language-specific settings
  (import ./languages.nix)
]

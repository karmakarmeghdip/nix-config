{
  vim.lsp.enable = true;
  vim.lsp.lspkind.enable = true;
  vim.lsp.formatOnSave = true;
  vim.languages = {
    enableTreesitter = true;
    nix.enable = true;
    nix.lsp.servers = [ "nixd" ];
    ts.enable = true;
    rust.enable = true;
  };
}

# NixOS/Home Manager module wrapper
# Import this in configuration.nix for system-wide neovim
{ config, lib, ... }:
{
  programs.nvf = {
    enable = true;
    settings = import ./default.nix { inherit lib; };
  };
}

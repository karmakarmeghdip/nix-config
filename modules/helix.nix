{ config, pkgs, ... }:

{
  catppuccin.helix.enable = false;
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
            "spacer"
          ];
          center = [
            "file-name"
            "file-modification-indicator"
          ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "spacer"
            "position-percentage"
            "spacer"
            "file-type"
            "spacer"
            "spacer"
            "spinner"
          ];
          separator = "";
          mode = {
            normal = "󰦨";
            insert = "";
            select = "";
          };
        };
      };
    };
  };
}

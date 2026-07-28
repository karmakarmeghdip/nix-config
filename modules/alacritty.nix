{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "ZedMono Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      window = {
        # opacity = 0.85;
        padding = {
          x = 4;
          y = 4;
        };
      };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-D"
        ];
      };
      env = {
        TERM = "tmux-256color";
      };
      cursor = {
        style = "Block";
      };
      selection = {
        save_to_clipboard = true;
      };
      scrolling = {
        history = 10000;
      };
    };
  };
}

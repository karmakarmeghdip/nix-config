{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "ZedMono Nerd Font";
      package = pkgs.nerd-fonts.zed-mono;
      size = 12;
    };
    settings = {
      # background_opacity = "0.65";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 4;
      scrollback_lines = 10000;

      # Development workflow improvements
      copy_on_select = "yes";
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      # Layout
      enabled_layouts = "tall:bias=50;full_size=1;mirrored=false";
    };
  };
}

{ config, pkgs, ... }:

{

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        # no_fade_in = true;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          # color = "rgba(0, 0, 0, 0.4)";
        }
      ];

    };
  };
}

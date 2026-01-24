{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = true;
      splash = false;

      wallpaper = [
        {
          monitor = "HDMI-A-2";
          path = "~/Pictures/Wallpaper";
          fit_mode = "fill";
          timeout = 300;
        }
      ];
    };
  };
}

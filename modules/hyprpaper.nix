{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "/home/mkarmakar/Pictures/Wallpaper/flowering-rain.png"
      ];

      wallpaper = [
        ",/home/mkarmakar/Pictures/Wallpaper/flowering-rain.png"
      ];
    };
  };
}

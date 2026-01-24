{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "/home/mkarmakar/Pictures/Wallpaper/bsod.png"
        "/home/mkarmakar/Pictures/Wallpaper/flowering-rain.png"
        "/home/mkarmakar/Pictures/Wallpaper/girl-stars.png"
        "/home/mkarmakar/Pictures/Wallpaper/sakura-gate.jpg"
        "/home/mkarmakar/Pictures/Wallpaper/wallhaven-vqoo1p.jpg"
        "/home/mkarmakar/Pictures/Wallpaper/wanderer.jpg"
        "/home/mkarmakar/Pictures/Wallpaper/waterfall.png"
      ];

      wallpaper = [
        "HDMI-A-2,/home/mkarmakar/Pictures/Wallpaper/girl-stars.png"
      ];
    };
  };
}

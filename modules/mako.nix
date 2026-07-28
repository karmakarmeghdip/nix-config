{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Appearance
      background-color = "#1e1e2eff"; # Catppuccin Mocha Base
      text-color = "#cdd6f4ff"; # Catppuccin Mocha Text
      border-color = "#89b4faff"; # Catppuccin Mocha Blue
      border-radius = 10;
      border-size = 2;
      padding = "10";

      # Layout
      width = 350;
      height = 150;
      margin = "10";

      # Behavior
      default-timeout = 5000; # 5 seconds
      ignore-timeout = false;

      # Grouping
      max-visible = 5;
      layer = "overlay";
      anchor = "top-right";
    };

    # Customization for specific urgencies
    extraConfig = ''
      [urgency=low]
      border-color=#a6e3a1

      [urgency=normal]
      border-color=#89b4fa

      [urgency=critical]
      border-color=#f38ba8
      default-timeout=0
    '';
  };
}

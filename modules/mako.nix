{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    # Appearance
    font = "JetBrainsMono Nerd Font 12";
    backgroundColor = "#1e1e2eff"; # Catppuccin Mocha Base
    textColor = "#cdd6f4ff"; # Catppuccin Mocha Text
    borderColor = "#89b4faff"; # Catppuccin Mocha Blue
    borderRadius = 10;
    borderSize = 2;
    padding = "10";
    
    # Layout
    width = 350;
    height = 150;
    margin = "10";
    
    # Behavior
    defaultTimeout = 5000; # 5 seconds
    ignoreTimeout = false;
    
    # Grouping
    maxVisible = 5;
    layer = "overlay";
    anchor = "top-right";
    
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

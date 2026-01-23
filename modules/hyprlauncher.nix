{ config, pkgs, ... }:

{
  services.hyprlauncher = {
    enable = true;
    settings = {
      general = {
        grab_focus = true;
      };
      
      cache = {
        path = "~/.local/share/hyprlauncher";
        enable = true;
      };
      
      finders = {
        # Available finders: math, desktop, unicode
        math = true;
        desktop = true;
        unicode = true;
        
        default_finder = "desktop";
        
        # Prefixes (single character only)
        desktop_prefix = "";      # no prefix for desktop apps
        unicode_prefix = ".";
        math_prefix = "=";
        font_prefix = "'";
        
        # Launch command prefix (useful for uwsm)
        # desktop_launch_prefix = "uwsm app --";
        
        desktop_icons = true;
      };
      
      ui = {
        width = 400;
        height = 260;
      };
    };
  };
}

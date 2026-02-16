{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_symlink = true;
      };

      preview = {
        max_width = 600;
        max_height = 900;
        image_filter = "lanczos3";
        image_quality = 75;
        sixel_fraction = 15;
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      opener = {
        edit = [
          {
            run = "hx $@";
            block = true;
          }
        ];
        play = [
          {
            run = "mpv $@";
            orphan = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = "xdg-open $@";
            desc = "Open";
          }
        ];
      };
    };
  };

  # Optional: specific packages useful for yazi previews if not already present
  home.packages = with pkgs; [
    ffmpegthumbnailer
    jq
    poppler
    fd
    ripgrep
    fzf
    zoxide
    imagemagick
  ];
}

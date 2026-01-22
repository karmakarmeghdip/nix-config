{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "meghdip";
  home.homeDirectory = "/home/mkarmakar";

  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "25.11";

  # Packages that don't have dedicated programs.* modules
  home.packages = with pkgs; [
    # Development tools
    nixd
    nixfmt
    helix
    cmake
    ninja
    nodejs
    dotnet-sdk
    gjs
    gtk3

    # CLI utilities
    aria2
    cabextract
    inxi
    speedtest-cli
    typst
    zsync
    fx # JSON viewer

    # Container/VM tools
    distrobox
    lazydocker
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # Shell aliases (applied to all shells)
  home.shellAliases = {
    # ls = "lsd";
    # ll = "lsd -l";
    # la = "lsd -la";
    # lt = "lsd --tree";
    cat = "bat";
    top = "btop";
    lg = "lazygit";
    lzd = "lazydocker";
  };

  # ─────────────────────────────────────────────────────────────
  # Programs with dedicated Home Manager modules
  # ─────────────────────────────────────────────────────────────

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Atuin - shell history sync
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
    };
  };

  # AWS CLI
  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "us-east-1";
        output = "json";
      };
    };
  };

  # Bat - cat replacement with syntax highlighting
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  # Btop - resource monitor
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      update_ms = 1000;
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editor = "hx";
    };
    extensions = [
      pkgs.gh-dash
    ];
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Delta - better git diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # Lazygit - terminal UI for git
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showRandomTip = false;
        showCommandLog = false;
        theme = {
          lightTheme = false;
          activeBorderColor = [
            "green"
            "bold"
          ];
          inactiveBorderColor = [ "white" ];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

  # LSD - ls replacement
  programs.lsd = {
    enable = true;
    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
      ];
      color = {
        when = "auto";
        theme = "default";
      };
      date = "relative";
      dereference = false;
      icons = {
        when = "auto";
        theme = "fancy";
        separator = " ";
      };
      layout = "grid";
      size = "default";
      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "first";
      };
    };
  };

  # MPV - media player
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
      gpu-context = "wayland";
      keep-open = true;
      volume = 100;
      volume-max = 200;
      osd-bar = false;
      border = false;
    };
    bindings = {
      "l" = "seek 5";
      "h" = "seek -5";
      "j" = "seek -60";
      "k" = "seek 60";
      "S" = "screenshot";
    };
  };

  # Zoxide - smarter cd
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    options = [
      "--cmd"
      "cd"
    ]; # Replace cd with zoxide
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "erasedups"
    ];
    historySize = 10000;
    historyFileSize = 20000;
  };

  # Direnv - directory-specific environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # FZF - fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Kitty terminal (required for Hyprland)
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 4;
      scrollback_lines = 10000;
    };
    themeFile = "Catppuccin-Mocha";
  };

  # Starship prompt (optional, uncomment if desired)
  # programs.starship = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   settings = {
  #     add_newline = true;
  #     character = {
  #       success_symbol = "[➜](bold green)";
  #       error_symbol = "[✗](bold red)";
  #     };
  #   };
  # };

  # ─────────────────────────────────────────────────────────────
  # Wayland / Hyprland
  # ─────────────────────────────────────────────────────────────

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Basic Hyprland configuration
      # Customize these according to your preferences
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = false;
        };
      };
      animations = {
        enabled = true;
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
    };
  };

  # ─────────────────────────────────────────────────────────────
  # XDG directories
  # ─────────────────────────────────────────────────────────────

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "video/*" = [ "mpv.desktop" ];
        "audio/*" = [ "mpv.desktop" ];
      };
    };
  };
}

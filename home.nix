{
  config,
  pkgs,
  catppuccin,
  ...
}:

{
  # Import modular configurations
  imports = [
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/fuzzel.nix
    ./modules/mako.nix
  ];

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
    nodejs
    bun
    gemini-cli-bin

    # CLI utilities
    aria2
    cabextract
    inxi
    speedtest-cli
    typst
    zsync
    fx # JSON viewer
    vivid # LS_COLORS generator

    # Container/VM tools
    distrobox
    lazydocker

    # System tools
    blueman
  ];

  catppuccin.enable = true;

  # Session variables
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # Shell aliases (applied to all shells)
  home.shellAliases = {
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
      pager = "less -FR";
    };
  };

  # Btop - resource monitor
  programs.btop = {
    enable = true;
    settings = {
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
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
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

  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Vi mode
      fish_vi_key_bindings

      # Better colors for ls
      set -gx LS_COLORS "$(vivid generate catppuccin-mocha 2>/dev/null || echo "")"
    '';
    shellAbbrs = {
      # Git abbreviations (expand on space)
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      # Home Manager stuff
      hms = "home-manager switch";
    };
    functions = {
      # Quick directory creation and cd
      mkcd = "mkdir -p $argv[1] && cd $argv[1]";
      # Extract various archive formats
      extract = ''
        switch $argv[1]
          case '*.tar.bz2'
            tar xjf $argv[1]
          case '*.tar.gz'
            tar xzf $argv[1]
          case '*.bz2'
            bunzip2 $argv[1]
          case '*.rar'
            unrar x $argv[1]
          case '*.gz'
            gunzip $argv[1]
          case '*.tar'
            tar xf $argv[1]
          case '*.tbz2'
            tar xjf $argv[1]
          case '*.tgz'
            tar xzf $argv[1]
          case '*.zip'
            unzip $argv[1]
          case '*.Z'
            uncompress $argv[1]
          case '*.7z'
            7z x $argv[1]
          case '*'
            echo "Cannot extract '$argv[1]'"
        end
      '';
    };
    plugins = [
      # Fish plugins can be added here
      # { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
  };

  # Direnv - directory-specific environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # FZF - fuzzy finder
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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

  # Starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
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
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "video/*" = [ "mpv.desktop" ];
        "audio/*" = [ "mpv.desktop" ];
      };
    };
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  targets.genericLinux.enable = true;
}

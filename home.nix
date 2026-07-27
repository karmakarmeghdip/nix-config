{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Import modular configurations
  imports = [
    ./modules/helix.nix
    ./modules/kitty.nix
    ./modules/yazi.nix
    ./modules/tmux.nix
    ./modules/neovide.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "meghdip";
  home.homeDirectory = "/home/mkarmakar";

  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "25.11";

  # Packages that don't have dedicated programs.* modules
  home.packages =
    with pkgs;
    [
      # System monitoring
      amdgpu_top
      mission-center

      # Development tools
      nodejs
      bun
      zed-editor
      devenv
      emacs

      # Tmux session manager (fuzzy switch/create sessions with fzf)
      sesh

      # CLI utilities
      aria2
      typst
      fx # JSON viewer
      vivid # LS_COLORS generator
      nix-index

      # Container/VM tools
      distrobox
      lazydocker

      # Games
      lutris

    ]
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      antigravity-cli
      opencode
      codex
    ]);

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  # catppuccin.cursors.enable = true;
  catppuccin.accent = "mauve";

  # GTK theming
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-GTK-Mauve-Dark";
      package = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "mauve" ];
        shade = "dark";
        size = "standard";
      };
    };
    # Explicitly set GTK4 theme to match GTK3 theme (silences deprecation warning)
    gtk4.theme = config.gtk.theme;
    iconTheme = lib.mkForce {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };
  };

  # Symlink GTK theme into ~/.themes for Flatpak apps.
  home.file.".themes/Catppuccin-GTK-Mauve-Dark".source =
    "${config.gtk.theme.package}/share/themes/Catppuccin-GTK-Mauve-Dark";

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
      pull.rebase = false;
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
       nrs = "sudo nixos-rebuild switch --flake ~/nix-config";
       # opencode (LLM CLI)
       oc = "opencode";
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
    # Let Atuin own Ctrl-R; clear fzf's history widget commands.
    historyWidget = {
      bash.command = "";
      fish.command = "";
    };
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

  # XDG MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
    };
  };

}

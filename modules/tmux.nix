{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";

    # Sane defaults
    prefix = "C-b";
    baseIndex = 1; # Start windows/panes at 1 (easier keyboard reach)
    keyMode = "vi";
    mouse = true;
    clock24 = true;
    escapeTime = 0; # No delay for escape key (important for Neovim/Helix)
    historyLimit = 50000;
    focusEvents = true; # Pass focus events through to apps (Helix, etc.)
    aggressiveResize = true;

    plugins = with pkgs.tmuxPlugins; [
      # Must be first: sets sensible defaults
      sensible

      # Vi-style pane navigation (h/j/k/l) + pain-free splits
      # <prefix>-   splits horizontal, <prefix>|  splits vertical
      pain-control

      # Clipboard integration (y to yank, Y to yank current line)
      yank

      # Persist sessions across reboots
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }

      # Automatic session saving every 15 minutes
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }

      # Catppuccin theme (auto-matched to catppuccin-mocha by catppuccin module)
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_status_left_separator '█'
          set -g @catppuccin_status_right_separator '█'
          set -g @catppuccin_status_connect_separator 'no'

          # Status bar components
          set -g @catppuccin_status_modules_right 'session date_time'
          set -g @catppuccin_date_time_text '%H:%M'
        '';
      }
    ];

    extraConfig = ''
      # ── Terminal ───────────────────────────────────────────────────────────
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

      # ── Window / pane behaviour ────────────────────────────────────────────
      set -g renumber-windows on     # Re-number windows when one is closed
      set -g set-titles on
      set -g set-titles-string '#S · #W'

      # ── Key bindings ───────────────────────────────────────────────────────
      # Reload config without restarting tmux
      bind r source-file ~/.config/tmux/tmux.conf \; display-message " Config reloaded"

      # Better split shortcuts (keep current path)
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      bind c new-window -c '#{pane_current_path}'

      # Vi-style copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Move between windows with Shift+Arrow (no prefix needed)
      bind -n S-Left  previous-window
      bind -n S-Right next-window

      # Quickly jump to last window
      bind Space last-window

      # ── Session management (sesh) ──────────────────────────────────────────
      # <prefix> T  — fuzzy-pick or create a session via sesh + fzf popup
      # Lists: active sessions, zoxide frecency dirs, and tmux-sessionizer dirs
      bind T display-popup -E -w 60% -h 50% "\
        sesh connect \"\$(sesh list --icons | \
          fzf \
            --ansi \
            --no-sort \
            --border-label ' sesh ' \
            --prompt '  ' \
            --header '  switch / create session' \
            --header-first \
            --bind 'ctrl-a:change-prompt(  )+reload(sesh list --icons)' \
            --bind 'ctrl-r:change-prompt(  )+reload(sesh list --icons --running)' \
            --bind 'ctrl-x:execute(tmux kill-session -t {2..})+reload(sesh list --icons)' \
            --preview 'sesh preview {}' \
            --preview-window 'right:55%:border-left' \
        )\""

      # ── Status bar ─────────────────────────────────────────────────────────
      set -g status-position bottom
      set -g status-interval 5
    '';
  };
}

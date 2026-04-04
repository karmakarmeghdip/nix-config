{
  config,
  pkgs,
  ...
}:

let
  # Helper function for noctalia IPC calls
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor config
      monitor = "HDMI-A-2, 2560x1440@120, 0x0, 1";

      # Basic Hyprland configuration
      # Customize these according to your preferences
      "$mod" = "SUPER";
      layerrule = [
        "blur on, match:namespace noctalia"
      ];
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, D, exec, noctalia-shell ipc call launcher toggle" # Noctalia launcher
        "$mod, M, exit"
        "$mod, L, exec, noctalia-shell ipc call lockScreen lock" # Noctalia lock screen
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, layoutmsg, promote" # Promote window to its own column
        "$mod, J, togglesplit"
        # Move focus (using layoutmsg for scrolling layout)
        "$mod, left, layoutmsg, focus l"
        "$mod, right, layoutmsg, focus r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Scrolling layout: Column resizing
        "$mod, equal, layoutmsg, colresize +0.1"
        "$mod, minus, layoutmsg, colresize -0.1"
        "$mod CTRL, equal, layoutmsg, colresize +conf"
        "$mod CTRL, minus, layoutmsg, colresize -conf"
        # Scrolling layout: Swap columns
        "$mod CTRL, left, layoutmsg, swapcol l"
        "$mod CTRL, right, layoutmsg, swapcol r"
        # Scrolling layout: Move layout by columns
        "$mod ALT, left, layoutmsg, move -col"
        "$mod ALT, right, layoutmsg, move +col"
        # Scrolling layout: Maximize column horizontally
        "$mod CTRL, F, layoutmsg, colresize 1.0"
        # Note: Overview mode ($mod + O) requires hyprexpo plugin which has build issues
        # Alternative: Use workspace switching ($mod + 1-0) or hyprctl commands
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

        # Screenshots
        "$mod, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"

        # Noctalia session menu (power menu)
        "$mod SHIFT, M, exec, noctalia-shell ipc call sessionMenu toggle"
      ];
      # Volume/brightness keys using noctalia OSD
      bindle = [
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "scrolling";
      };
      scrolling = {
        column_width = 0.5;
        focus_fit_method = 1;
        follow_focus = true;
        follow_min_visible = 0.4;
        direction = "right";
        fullscreen_on_one_column = true;
      };
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
        };
        shadow = {
          enabled = false;
        };
      };
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
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
}

{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    # Waybar settings
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 44;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "{}% ";
          interval = 1;
        };

        memory = {
          format = "{used:0.1f}G/{total:0.1f}G ";
          interval = 1;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    # Style
    style = ''
      * {
        font-size: 20px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: @surface0;
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: @overlay0;
      }

      #workspaces {
        background: @surface0;
        margin: 5px;
        padding: 0 5px;
        border-radius: 16px;
        color: @mauve;
      }

      #workspaces button {
        padding: 0 5px;
        color: @subtext0;
        border-radius: 10px;
      }

      #workspaces button.active {
        color: @base;
        background: @mauve;
      }

      #workspaces button.focused {
        color: @mauve;
        background: @surface1;
      }

      #workspaces button.urgent {
        color: @base;
        background: @red;
      }

      #workspaces button:hover {
        background: @surface1;
        color: @text;
      }

      #window,
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 20px;
        margin: 5px 2px;
        color: @text;
        border-radius: 16px;
        background: @surface0;
      }

      #window {
        background: transparent;
        color: @subtext1;
      }

      #clock {
        color: @blue;
      }

      #battery {
        color: @green;
      }

      #battery.charging, #battery.plugged {
        color: @sky;
      }

      #battery.critical:not(.charging) {
        background-color: @red;
        color: @base;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
        color: @sapphire;
      }

      #memory {
        color: @sky;
      }

      #network {
        color: @teal;
      }

      #network.disconnected {
        color: @red;
      }

      #pulseaudio {
        color: @maroon;
      }

      #pulseaudio.muted {
        color: @overlay0;
      }

      #tray {
        background: @surface0;
      }
    '';
  };
}

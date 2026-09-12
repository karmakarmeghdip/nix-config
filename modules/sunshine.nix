{ config, pkgs, ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    # Required for Wayland (GNOME) KMS screen capture on non-wlroots compositors.
    # Omit this if you switch to Xorg.
    capSysAdmin = true;
    openFirewall = true;
  };

  # NOTE: `services.sunshine.settings` and `services.sunshine.applications`
  # are intentionally left unset so you can configure Sunshine from its
  # Web UI (https://localhost:47989) after first start.
  # Setting either option would lock the Web UI and force file-only config.
}

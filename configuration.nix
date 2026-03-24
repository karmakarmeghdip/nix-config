{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./modules/samba.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable nftables (modern replacement for iptables)
  networking.nftables.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "en_IN/UTF-8" ];

  # Define Indian formatting specifically to fix the LC_* errors
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  catppuccin.enable = true;
  catppuccin.cache.enable = true;
  catppuccin.cursors.enable = true;

  # Display manager - sysc-greet (Wayland-native)
  services.sysc-greet = {
    enable = true;
    compositor = "hyprland";
  };

  # services.kmscon = {
  #   enable = true;
  #   fonts = [
  #     {
  #       name = "ZedMono Nerd Font";
  #       package = pkgs.nerd-fonts.zed-mono;
  #     }
  #   ];
  # };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Required for Noctalia shell power profile feature
  services.tuned.enable = true;

  # GNOME Keyring for secret storage (used by VSCode, browsers, etc.)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Polkit for privilege escalation dialogs
  security.polkit.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.meghdip = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/mkarmakar";
    description = "Meghdip Karmakar";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]; # Enable 'sudo' for the user.
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    fastfetch
    kitty
  ];

  # System fonts (including CJK support for Japanese/Korean/Chinese)
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };

  programs.steam = {
    enable = true;

  };

  programs.fish.enable = true;

  # Enable dconf for GTK settings (required for portal color-scheme detection)
  programs.dconf.enable = true;

  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        # Route Settings interface to darkman for color-scheme detection
        "org.freedesktop.impl.portal.Settings" = [ "darkman" ];
      };
    };
  };

  virtualisation.podman.enable = true;
  
  # Waydroid with nftables support
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      X11Forwarding = true;
    };
  };
  programs.ssh.setXAuthLocation = true;

  # Open SSH port in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

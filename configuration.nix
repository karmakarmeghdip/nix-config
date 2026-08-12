{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./modules/paseo.nix
  ];

  # CachyOS kernel overlay for best performance
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

  # Enable nftables (modern replacement for iptables)
  networking.nftables.enable = true;

  # Tailscale setup
  services.tailscale.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

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

  # Enable Japanese IME
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  catppuccin.enable = true;
  catppuccin.autoEnable = true;
  catppuccin.cache.enable = true;
  # catppuccin.cursors.enable = true;

  # Display manager - GDM (GNOME)
  services.displayManager.gdm.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.steam-hardware.enable = true;

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
    cloudflare-warp
    inputs.app-manager.packages.x86_64-linux.default
    gnomeExtensions.user-themes
    gnome-tweaks
  ];

  # System fonts for GNOME and general UI
  fonts.packages = with pkgs; [
    inter
    cantarell-fonts # GNOME default UI font
    liberation_ttf # Metric-compatible fallback for Arial/Times/Courier
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

  programs.gamemode.enable = true;

  programs.gamescope.enable = true;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamescope
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.fish.enable = true;

  # Desktop environments - GNOME
  services.desktopManager.gnome.enable = true;

  # Flatpak support
  services.flatpak.enable = true;

  # Appimage support
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Warp VPN support
  services.cloudflare-warp = {
    enable = true;
    openFirewall = true; # Opens required UDP ports
  };

  # Allow Flatpak apps to follow symlinks into the Nix store (e.g. for GTK themes).
  # Reset first to clear any previously set GTK_THEME or ~/.themes overrides,
  # then grant read-only access to the entire Nix store.
  system.activationScripts.flatpakNixStore = ''
    ${pkgs.flatpak}/bin/flatpak override --system --reset
    ${pkgs.flatpak}/bin/flatpak override --system \
      --filesystem=/nix/store:ro
  '';

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
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
  nix.settings.auto-optimise-store = true;
  nix.settings.extra-substituters = [
    "https://cache.numtide.com"
    "https://attic.xuyh0120.win/lantian"
  ];
  nix.settings.extra-trusted-public-keys = [
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # Open SSH port in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    59100
  ];
  networking.firewall.allowedUDPPorts = [
    59200
    59100
    config.services.tailscale.port
  ];
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

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

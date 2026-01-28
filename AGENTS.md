# Agent Guide for NixOS Configuration

This repository contains the NixOS system configuration and Home Manager user configuration for the user `meghdip`. It utilizes Nix Flakes for reproducibility and dependency management.

## 1. Build & Deployment Commands

Since this is a system configuration repository, "building" implies applying the configuration to the running system.

### Applying Configuration
To apply the changes to the system (both NixOS and Home Manager):
```bash
sudo nixos-rebuild switch --flake .
```
*   **Note:** This command requires `sudo` privileges.
*   The `--flake .` argument assumes you are in the root of the repository. If running from elsewhere, use `--flake ~/nix-config`.
*   This command will compile the new system closure, activate it, and update the bootloader entries.

### Formatting & Linting
The repository uses `nixfmt` for code formatting. Ensure all `.nix` files are formatted before committing.
```bash
# Format all .nix files in the current directory and subdirectories
nixfmt .
```

### Testing
To check for syntax errors and flake validity without applying changes:
```bash
# Check the flake for errors
nix flake check

# Build the system closure without switching (dry run build)
nix build .#nixosConfigurations.nixos.config.system.build.toplevel
```

### Updating Dependencies
To update the flake inputs (e.g., `nixpkgs`, `home-manager`):
```bash
nix flake update
```

## 2. Project Structure

*   **`flake.nix`**: The entry point. Defines inputs (nixpkgs, home-manager, etc.) and outputs (system configurations).
*   **`configuration.nix`**: System-level configuration (bootloader, networking, users, system packages, hardware settings).
*   **`home.nix`**: Home Manager configuration for user `meghdip` (shell aliases, user programs, dotfiles management).
*   **`modules/`**: Directory containing modularized configuration files (e.g., `hyprland.nix`, `waybar.nix`, `helix.nix`).
*   **`hardware-configuration.nix`**: Hardware-specific configuration (usually auto-generated, avoid manual edits unless necessary).

## 3. Code Style & Conventions

### General Nix Style
*   **Indentation**: Use 2 spaces for indentation.
*   **Formatting**: Strictly adhere to `nixfmt` output.
*   **Strings**: Use double quotes `"` for simple strings and `''` for multiline strings.

### Imports & Modularity
*   **New Features**: When adding a substantial new feature or program configuration, create a separate file in the `modules/` directory.
*   **Registering Modules**:
    *   If it's a user-specific module (most common), add it to the `imports` list in `home.nix`.
    *   If it's a system-wide module, add it to the `modules` list in `flake.nix` or imports in `configuration.nix`.
*   **Paths**: Use relative paths for imports (e.g., `./modules/my-module.nix`).

### Naming Conventions
*   **Files**: Use `kebab-case` for filenames (e.g., `hyprland-config.nix`).
*   **Variables**: Use `camelCase` for variable names within let blocks.
*   **Options**: Follow standard NixOS/Home Manager option hierarchy (e.g., `programs.git.enable`).

### Package Management
*   **`with pkgs;`**: It is acceptable and encouraged to use `with pkgs;` when defining lists of packages to avoid repetitive `pkgs.` prefixes.
    ```nix
    home.packages = with pkgs; [
      firefox
      ripgrep
      # ...
    ];
    ```
*   **Unfree Packages**: `allowUnfree` is enabled. You can freely add unfree packages (like generic `vscode`, `steam`, etc.).

### Error Handling & Safety
*   **Backups**: While NixOS allows rollbacks, always ensure the git repository is clean or changes are committed before running `nixos-rebuild switch`.
*   **Critical Services**: Be cautious when modifying `networking`, `boot`, or `users` configurations in `configuration.nix`.
*   **Secrets**: Do **not** commit actual secrets (API keys, passwords) directly to this repository unless they are encrypted (e.g., with `sops-nix` or `git-crypt`) or are just placeholders.

## 4. Specific Configuration Details

### Hyprland & Wayland
*   The system uses Hyprland as the window manager.
*   Configuration is split between `configuration.nix` (system enable) and `modules/hyprland.nix` (user config).
*   Related tools (Waybar, Fuzzel, Mako) have their own modules in `modules/`.

### Shell (Fish)
*   Fish is the default shell.
*   Aliases and abbreviations are managed in `home.nix` under `programs.fish`.
*   When adding new aliases, check `home.shellAliases` or `programs.fish.shellAbbrs` in `home.nix`.

### Theming
*   **Catppuccin** is used as the global theme (Mocha variant).
*   It is applied via the `catppuccin` flake input and modules.
*   When adding new tools, don't try to manually configure colors, the catppuccin module will automatically match colors to `catppuccin-mocha`.

## 5. Research Tools

Use the `nixos_nix` tool (NixOS MCP Server) whenever necessary, for example discovering options and packages. It provides accurate and up-to-date information on the following:

*   **NixOS packages**: 130K+ packages that actually exist.
*   **NixOS options**: 23K+ ways to configure your system.
*   **Home Manager**: 5K+ options for dotfile enthusiasts.
*   **nix-darwin**: 1K+ macOS settings Apple doesn't document.
*   **Nixvim**: 5K+ options for Neovim configuration via NuschtOS search.
*   **FlakeHub**: 600+ flakes from FlakeHub.com registry.
*   **Package versions**: Historical versions with commit hashes via NixHub.io.

## 6. Development Workflow for Agents

1.  **Analyze**: Read `flake.nix` to understand the inputs and `home.nix` to see currently installed packages.
2.  **Locate**: Use `ls modules/` to see if a configuration already exists for the tool you are modifying.
3.  **Edit**: Make changes to the relevant `.nix` file.
4.  **Verify**:
    *   Run `nixfmt path/to/file.nix` to format your changes.
    *   Run `nix flake check` to ensure no syntax errors.
    *   **Crucial**: Ask the user before running `nixos-rebuild switch`. This changes their active system state.
5.  **Commit**: Create a commit with a descriptive message (e.g., `feat: add obs-studio`, `fix: waybar spacing`).

## 7. Example Snippets

### Adding a new Home Manager Module
Create `modules/new-tool.nix`:
```nix
{ config, pkgs, ... }:

{
  programs.new-tool = {
    enable = true;
    settings = {
      foo = "bar";
    };
  };
}
```
Then import in `home.nix`:
```nix
imports = [
  # ... existing imports
  ./modules/new-tool.nix
];
```

### Adding a System Package
In `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  pciutils
  usbutils
];
```

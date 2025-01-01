# NixOS Configuration

A modular NixOS configuration using Flakes and Home Manager, supporting multiple profile builds for different systems.

## Structure

```
.
├── flake.nix             # Main flake configuration
├── profiles/             # System-specific profiles
│   ├── laptop/           # Laptop-specific configuration
│   ├── template/         # Template for new profiles
│   └── xen-vm/           # Xen VM configuration
├── system/               # System-wide configurations
│   ├── sshd.nix          # SSH daemon configuration
│   ├── steam.nix         # Steam gaming setup
│   ├── tailscale.nix     # Tailscale VPN configuration
│   ├── virt.nix          # Virtualization settings
│   └── xrdp.nix          # Remote desktop protocol
└── user/                 # User-specific configurations
    ├── desk-env/         # Desktop environment settings
    │   └── gnome.nix     # GNOME configuration
    ├── git.nix           # Git configuration
    └── shell/            # Shell configurations
        ├── sh.nix        # Shell settings
        └── starship.toml # Starship prompt configuration
```

## Features

- **Profile-based Configuration**: Supports multiple system profiles (laptop, VM, etc.)
- **Home Manager Integration**: User environment management with home-manager
- **Hyprland Desktop**: Configured with Wayland and Hyprland window manager
- **Development Tools**: Includes various development tools and configurations
- **System Services**: Configured services including SSH, Tailscale, and audio

## Setup

### Prerequisites

- NixOS installed with flakes enabled
- Git for cloning the repository

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/.dotfiles
   cd ~/.dotfiles
   ```
   
2. Copy the hardware-configuration.nix file from /etc/nixos/hardware-configuration.nix that was automatically generated when you installed NixOS on your device to the profile directory.
   If you need to generate a new config, you can use
   ```nix
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```

3. Update the system settings in `flake.nix`: (The Profile determines the directory for the configuration.nix, hardware-configuration.nix, and home.nix)
   ```nix
   systemSettings = {
     system = "x86_64-linux";
     hostname = "your-hostname";
     profile = "laptop"; # or another profile
     timezone = "America/New_York";
   };
   ```

4. Update the user settings:
   ```nix
   userSettings = {
     username = "your-username";
     name = "Your Name";
     email = "your.email@example.com";
     dotfilesDir = "~/.dotfiles";
     font = "Intel One Mono";
     fontPkg = pkgs.intel-one-mono;
   };
   ```

5. Build and switch to the configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#
   ```

6. Apply home-manager configuration:
   ```bash
   home-manager switch --flake .#
   ```

## Profiles

### Laptop Profile
- Hyprland window manager
- Power management
- Bluetooth support
- Pipewire audio
- TUI greeting screen

### Xen VM Profile
- Minimal configuration for virtual machines
- Basic system services

### Template Profile
- Base configuration for creating new profiles

## Customization

### Adding a New Profile

1. Copy the template profile:
   ```bash
   cp -r profiles/template profiles/new-profile
   ```

2. Modify the configuration files in the new profile directory:
   - `configuration.nix`: System configuration
   - `home.nix`: Home-manager configuration

3. Update `flake.nix` to recognize the new profile (it's automatic with the current setup)

### Modifying System Services

System-wide services are configured in the `system/` directory:
- `sshd.nix`: SSH server configuration
- `tailscale.nix`: Tailscale VPN setup
- `virt.nix`: Virtualization configuration
- `steam.nix`: Gaming setup
- `xrdp.nix`: Remote desktop configuration

### User Configuration

User-specific configurations are managed in the `user/` directory:
- `desk-env/`: Desktop environment configurations
- `shell/`: Shell and prompt settings
- `git.nix`: Git configuration

## Maintenance

### Updating

Update flake inputs:
```bash
nix flake update
```

Apply updates:
```bash
sudo nixos-rebuild switch --flake .#
home-manager switch --flake .#
```

### Troubleshooting

If you encounter issues:
1. Check the system journal: `journalctl -xb`
2. Verify flake inputs: `nix flake check`
3. Test configuration: `sudo nixos-rebuild test --flake .#`


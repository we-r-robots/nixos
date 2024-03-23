# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, pkgs-stable, lib, systemSettings, userSettings, authorizedKeys, ... }:

let
  sshPublicKey = authorizedKeys.homelab;
in
{
  imports =
    [ # Include the results of the hardware scan.
      #inputs.sops-nix.nixosModules.sops
      ./hardware-configuration.nix
      ../../system/sshd.nix
      ../../system/tailscale.nix
      #../../system/xrdp.nix
      #../../system/virt.nix # Enables virtualization and installs packages
      #../../system/steam.nix # Enables and installs Steam
    ];
 
  # Pass the required variables to the sshd.nix module
  _module.args = {
    userSettings = userSettings;
    inherit sshPublicKey;
  };

  # Bootloader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/xvda";
  # boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable gnome Desktop with Wayland
  #services.xserver = {
  #  enable = true;
  #  displayManager.gdm = {
  #    enable = true;
  #    wayland = true;
  #  };
  # desktopManager.gnome.enable = true;    
  #};

  # Enable Plasma Desktop Env w/ Wayland
  services.xserver = {
    enable = true;
    displayManager.sddm.wayland.enable = true;    
  };
  services.desktopManager.plasma6.enable = true;

  # Configure ZSH as default shell
  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Configure default firewall rules
  networking.firewall.allowedTCPPorts = [ 3389 389 5900 ];


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$iFGbtpE7wyyXQtWT$YioYoLoZzEJ5AMNENYKPAp0JLZCmEhyT.g9IuDEymQ0TkN4IIvYizqksM2/7AYE6Dnhf6uWSaZoFXX9JfuiZK.";
    packages = with pkgs; [];  
  };

  # SOPS Secrets setup
  #sops.defaultSopsFile = ./secrets/secrets.yaml;
  #sops.defaultSopsFormat = "yaml";
  
  #sops.age.keyFile = "/home/${userSettings.username}/.config/sops/age/keys.txt";

  #sops.secrets.example-key = { };
  #sops.secrets."myservice/my_subdir/my_secret" = {
  #  owner = "${userSettings.username}";
  #};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    git
    firefox
    remmina
    vscode-with-extensions
    sops
    neofetch
    tailscale
    tailscale-systray
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
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

{
  description = "Bender's Basic Ass Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    #sops-nix = {
    #  url = "github:Mic92/sops-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-stable, home-manager, ... }:
    let
      ##### SYSTEM SETTINGS #####
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        profile = "laptop";
        timezone = "America/New_York";
      };

      ##### USER SETTINGS #####
      userSettings = {
        username = "bender";
        name = "Ensef";
        email = "ensef@proton.me";
        dotfilesDir = "~/.dotfiles";
        font = "Intel One Mono";
        fontPkg = pkgs.intel-one-mono;
      };

      ##### SSH KEYS #####
      authorizedKeys = {
        homelab = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8t27FNhlDFTBWrTw8I1k4CZpduNZeou/Cjr+7oF4RIO6S5iBKn+oBUCN+ejSpdc3nDyEtyjrV9cZ+Bgg7DbGTtm7imiFRUNIbwd3vz/6A9f+wUzKPhvcqVig+OClNb/GxHVBvZGNWstmf111tgE52YZbrGQjO86hoqm5z8K86wFo+rJ2rQEFzJYRwew9hJ/Db8HKD2ypcya6YICR9hJobTL/EszMWqQnKgxOMyvkgfLcyQLvq6KWNoON7S2kX697QRtnOazkI1/w3UOXLuNS/XVSLwrmED0JqS9Wa8J0NVsQKtN2HLEfChrq9/m43V1MTWY2p/tVslMBCElaqagc97GTL2E5E42xirukK7AujrnunGj/YSPoe8aZF0B1bNubYmfVfm4WhkDlCxn7eY7RMQE+gTJ059jlL/q88zsCDZ8j406bwiQoJ86sC9MS6Zvdb+11r0NO2I4KPYVWp7Cm60fhyXAZk0SkRpVkHuCUmNExwlTImoonKeSjvo9f0ZtE= ensef@fedora";
      };

      ##### PACKAGE MANAGER SETTINGS #####
      pkgs-stable = import nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs = import nixpkgs {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      ##### CONFIGURE LIB #####
      lib = nixpkgs.lib;

    in {
      homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit authorizedKeys;
            inherit pkgs-stable;
          };
        };
      };

      nixosConfigurations = {
        ${systemSettings.hostname} = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit authorizedKeys;
            inherit pkgs-stable;
          };
        };
      };
    };
}

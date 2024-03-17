{
  description = "My First Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #sops-nix = {
    #  url = "github:Mic92/sops-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      ##### SYSTEM SETTINGS #####
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        profile = "template";
        timezone = "America/New_York";
      };

      ##### USER SETTINGS #####
      userSettings = {
        username = "bender";
        name = "Ensef";
        email = "ensef@proton.me";
        dotfilesDir = "~/.dotfiles";
        font = "Intel One Mono";
        fontPkg = nixpkgs.legacyPackages.${systemSettings.system}.intel-one-mono;
      };

      authorizedKeys = {
        homelab = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8t27FNhlDFTBWrTw8I1k4CZpduNZeou/Cjr+7oF4RIO6S5iBKn+oBUCN+ejSpdc3nDyEtyjrV9cZ+Bgg7DbGTtm7imiFRUNIbwd3vz/6A9f+wUzKPhvcqVig+OClNb/GxHVBvZGNWstmf111tgE52YZbrGQjO86hoqm5z8K86wFo+rJ2rQEFzJYRwew9hJ/Db8HKD2ypcya6YICR9hJobTL/EszMWqQnKgxOMyvkgfLcyQLvq6KWNoON7S2kX697QRtnOazkI1/w3UOXLuNS/XVSLwrmED0JqS9Wa8J0NVsQKtN2HLEfChrq9/m43V1MTWY2p/tVslMBCElaqagc97GTL2E5E42xirukK7AujrnunGj/YSPoe8aZF0B1bNubYmfVfm4WhkDlCxn7eY7RMQE+gTJ059jlL/q88zsCDZ8j406bwiQoJ86sC9MS6Zvdb+11r0NO2I4KPYVWp7Cm60fhyXAZk0SkRpVkHuCUmNExwlTImoonKeSjvo9f0ZtE= ensef@fedora";
      };
    in {
      homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${systemSettings.system};
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/home.nix")
          ];
          extraSpecialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit authorizedKeys;
          };
        };
      };

      nixosConfigurations = {
        ${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
          ];
          specialArgs = {
            inherit systemSettings;
            inherit userSettings;
            inherit authorizedKeys;
          };
        };
      };
    };
}

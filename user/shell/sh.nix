{ config, pkgs, ... }:

let
  myAliases = {
    hfp = "home-flake-profile";
    nr = "nix-rebuild";
  };

  homeFlakeProfile = ''
    function home-flake-profile {
      local profile="$1"
      home-manager switch --flake "/home/$USER/.dotfiles/profiles/"
    }
  '';

  nixRebuild = ''
    function nix-rebuild {
      local profile="$1"
      sudo nixos-rebuild switch --flake "/home/$USER/.dotfiles/"
    }
  '';
in
{
  # Initialize Bash and default configurations
  programs.bash = {
    enable = true;
    initExtra = ''
      ${homeFlakeProfile}
      ${nixRebuild}
    '';
    shellAliases = myAliases;
  };

  # Initialize ZSH and default configurations
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };   
    initExtra = ''
      ${homeFlakeProfile}
      ${nixRebuild}
    '';
    shellAliases = myAliases;
  };
}

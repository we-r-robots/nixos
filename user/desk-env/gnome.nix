{ config, lib, pkgs, userSettings, systemSettings, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-shell
    gnome.gnome-control-center
    gnome.gnome-terminal
    # Add more GNOME packages as needed
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-animations = true;
      # Add more GNOME desktop interface settings
    };

    "org/gnome/mutter" = {
      center-new-windows = true;
      # Add more GNOME Mutter settings
    };

    # Add more GNOME dconf settings
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    font = {
      name = "DejaVu Sans";
      size = 11;
    };
    # Add more GTK settings
  };

  # Add more GNOME-related configurations
}

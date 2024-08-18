### Tailscale module
{ pkgs, lib, config, userSettings, ... }:

{
  # Tailscale enable and config
  services.tailscale = {
    enable = true;
    port = 0;
    authKeyFile = "/home/${userSettings.username}/jingle/tailscale.key";
    openFirewall = true;
    interfaceName = "tail0";
    useRoutingFeatures = "client";
    #overrideLocalDns = "true";
    extraUpFlags = ["--accept-routes=true"];
  };
}

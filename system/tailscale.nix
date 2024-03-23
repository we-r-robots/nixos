### Tailscale module
{ pkgs, lib, config, ... }:

# Tailscale enable and config
services.tailscale {
  enable = true;
  port = 0;
  authKeyFile = "tskey-auth-khNqRw7Fqz11CNTRL-7aaRvi5Mo9NSAYezvs289N52k3yoPMDtd";
  openFirewall = true;
  interfaceName = "tail0"
  useRoutingFeatures = "client"
};

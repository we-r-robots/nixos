{config, lib, pkgs, userSettings, systemSettings, ... }:

{
services.xrdp.enable = true;
services.xrdp.defaultWindowManager = "metacity";
services.xrdp.openFirewall = true;
}

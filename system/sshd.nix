{ userSettings, sshPublicKey, ... }:

{
  # Enable SSH
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.${userSettings.username}.openssh.authorizedKeys.keys = [
    sshPublicKey
  ];
}

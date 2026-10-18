{ config, ... }: {
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityFile = [ config.profile.sshKeyPath ];
        ServerAliveCountMax = 5;
        ServerAliveInterval = 10;
      };
      bilbo.HostName = "bilbo.fnune.com";
    };
  };
}

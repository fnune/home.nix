{ config, ... }: {
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      addKeysToAgent = "yes";
      identityFile = [ config.profile.sshKeyPath ];
      serverAliveCountMax = 5;
      serverAliveInterval = 10;
    };
    matchBlocks.bilbo.hostname = "bilbo.fnune.com";
  };
}

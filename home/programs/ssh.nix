{config, ...}: {
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      identityFile = [config.profile.sshKeyPath];
      serverAliveCountMax = 5;
      serverAliveInterval = 10;
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";
    SSH_ASKPASS = "/usr/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}

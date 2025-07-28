_: {
  users.users.fausto.extraGroups = ["wheel"];

  # Enable full YubiKey functionality
  services.pcscd.enable = true;

  # Prefer GUI program for SSH unlocks even if requested from a terminal
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
  programs = {
    ssh = {
      startAgent = true;
      enableAskPassword = true;
    };
    gnupg = {
      agent = {
        enable = true;
      };
    };
  };
}

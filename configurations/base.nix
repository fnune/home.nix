{ config, username, ... }: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables.NH_SHOW_ACTIVATION_LOGS = "1";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  programs.nh.enable = true;
  targets.genericLinux.enable = true;
  news.display = "silent";
  systemd.user.startServices = "sd-switch";
  systemd.user.sessionVariables.PATH = "${config.home.homeDirectory}/.nix-profile/bin:$PATH";

  imports = [ ../modules/options.nix ];
}

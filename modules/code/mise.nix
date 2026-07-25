{pkgs-unstable, ...}: {
  programs.mise = {
    enable = true;
    package = pkgs-unstable.mise;
    enableZshIntegration = true;
  };
}

{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  imports = [./slack.nix ./playwright.nix];

  home = {
    packages = (with pkgs.unstable; [lefthook micromamba overmind ssm-session-manager-plugin]) ++ (with pkgs; [awscli2]);

    file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
    file."${monorepo}/.nvim.lua".source = ./nvim.lua;

    activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
    '';
  };
}

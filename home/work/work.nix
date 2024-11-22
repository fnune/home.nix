{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home = {
    packages = with pkgs.unstable; [awscli2 lefthook micromamba overmind ssm-session-manager-plugin];

    file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
    file."${monorepo}/.nvim.lua".source = ./nvim.lua;

    activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
    '';
  };
}

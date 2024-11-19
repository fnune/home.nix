{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home = {
    packages = with pkgs.unstable; [micromamba overmind awscli2 ssm-session-manager-plugin];

    file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
    file."${monorepo}/.nvim.lua".source = ./nvim.lua;

    activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
    '';
  };
}

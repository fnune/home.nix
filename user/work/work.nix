{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home = {
    packages = (with pkgs.unstable; [overmind graphite-cli heroku]) ++ (with pkgs; [zoom-us]);

    file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
    file."${config.home.homeDirectory}/.zsh/includes/graphite".source = ./graphite.sh;
    file."${monorepo}/.nvim.lua".source = ./nvim.lua;

    activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
    '';
  };
}

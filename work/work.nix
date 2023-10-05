{
  pkgs,
  config,
  lib,
  ...
}: let
  launcher = pkgs.writeShellScriptBin "t" (builtins.readFile ./launch.sh);
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home.packages = [launcher pkgs.overmind pkgs.cypress];

  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;

  home.activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
  '';
}

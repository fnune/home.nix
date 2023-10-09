{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home.packages = [pkgs.overmind pkgs.cypress pkgs.zoom-us];

  home.file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
  home.file."${monorepo}/.memfault_cfg.yml".source = ./memfault_cfg.yml;
  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;
  programs.git.ignores = [".memfault_cfg.yml"];

  home.activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
  '';
}

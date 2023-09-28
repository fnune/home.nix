{
  pkgs,
  config,
  ...
}: let
  launcher = pkgs.writeShellScriptBin "t" (builtins.readFile ./launch.sh);
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  home.packages = [launcher];
  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;
}

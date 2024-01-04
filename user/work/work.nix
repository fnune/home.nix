{
  pkgs,
  config,
  lib,
  ...
}: let
  monorepo = "${config.home.homeDirectory}/Development/memfault";
in {
  nixpkgs.overlays = [
    (final: prev: {
      cypress = prev.cypress.overrideAttrs (_: rec {
        version = "13.6.0";
        src = pkgs.fetchzip {
          url = "https://cdn.cypress.io/desktop/${version}/linux-x64/cypress.zip";
          sha256 = "sha256-bujZE86RRK3PJ5fbIkLJ2hccDJwZTlC+NlnBfF4iqxA=";
        };
      });
    })
  ];

  home.packages = with pkgs; [overmind cypress zoom-us graphite-cli heroku];

  home.file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;

  home.activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
  '';
}

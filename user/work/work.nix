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
        version = "13.3.3";
        src = pkgs.fetchzip {
          url = "https://cdn.cypress.io/desktop/${version}/linux-x64/cypress.zip";
          sha256 = "sha256-CZPjnZ0MjyI6ppobJR2dOM8YPWe1LrxYmXaL5vk2kvg";
        };
      });
    })
  ];

  home.packages = with pkgs; [overmind cypress zoom-us graphite-cli heroku];

  home.file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
  home.file."${monorepo}/.memfault_cfg.yml".source = ./memfault_cfg.yml;
  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;
  programs.git.ignores = [".memfault_cfg.yml"];

  home.activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
  '';
}

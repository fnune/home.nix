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
        version = "13.3.0";
        src = pkgs.fetchzip {
          url = "https://cdn.cypress.io/desktop/${version}/linux-x64/cypress.zip";
          sha256 = "sha256-12HQAQVyNcR7Ye3+eoYqwS0gUtOHuKTnsmEDUlXwWks";
        };
      });
    })
  ];

  home.packages = with pkgs; [overmind cypress zoom-us graphite-cli];

  home.file."${config.home.homeDirectory}/.zsh/includes/t".source = ./launch.sh;
  home.file."${monorepo}/.memfault_cfg.yml".source = ./memfault_cfg.yml;
  home.file."${monorepo}/.nvim.lua".source = ./nvim.lua;
  programs.git.ignores = [".memfault_cfg.yml"];

  home.activation.writeEnvrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo '${builtins.readFile ./envrc.sh}' > ${monorepo}/.envrc
  '';
}

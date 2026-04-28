{pkgs, ...}: {
  improved-ft-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "improved-ft.nvim";
    version = "unstable-2026-04-28";
    src = pkgs.fetchFromGitHub {
      owner = "backdround";
      repo = "improved-ft.nvim";
      rev = "f2259e9c4123339cb99430befcabf22f4689b97c";
      hash = "sha256-gF3ZyprH7cl0ddhfAUIUL/drPJCndWD1gWKkBCUKJ3I=";
    };
    nvimSkipModule = [
      "improved-ft.rabbit-hop.lua.rabbit-hop.api.init"
      "improved-ft.rabbit-hop.lua.rabbit-hop.pattern-iterator.lua.pattern-iterator.init"
      "improved-ft.rabbit-hop.lua.rabbit-hop.pattern-iterator.lua.pattern-iterator.position.init"
      "improved-ft.rabbit-hop.lua.rabbit-hop.pattern-iterator.lua.pattern-iterator.search-pattern.init"
    ];
  };

  markdown-plus-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "markdown-plus.nvim";
    version = "unstable-2026-04-28";
    src = pkgs.fetchFromGitHub {
      owner = "YousefHadder";
      repo = "markdown-plus.nvim";
      rev = "74d9a854b39dc76d5a29c8954622d16d116fca1e";
      hash = "sha256-AzlZlcQP85PxA4YLdj6a+B/IGh7u1dWaD4zdCXQs4Yw=";
    };
  };

  nvim-fundo = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-fundo";
    version = "unstable-2026-04-28";
    src = pkgs.fetchFromGitHub {
      owner = "kevinhwang91";
      repo = "nvim-fundo";
      rev = "c2b83cb19e4ac475f2b08aaf775afe3da19bc495";
      hash = "sha256-PGebG5bhwXYJ6cv1wSB/WOJZucoL6FGBiGdxkEtPl04=";
    };
    dependencies = [pkgs.vimPlugins.promise-async];
    nvimSkipModule = [
      "fundo.fs.init"
      "fundo.fs.uvwrapper"
      "fundo.lib.mutex"
      "fundo.lib.semaphore"
      "fundo.main"
      "fundo.manager"
      "fundo.model.undo"
    ];
  };

  standard = pkgs.vimUtils.buildVimPlugin {
    pname = "standard";
    version = "unstable-2026-04-28";
    src = pkgs.fetchFromGitHub {
      owner = "fnune";
      repo = "standard";
      rev = "0b1c270fa074fb7c14709d17f8a34a7a7a94b33b";
      hash = "sha256-5yf7FJW1w8FH53ZAbyRrTYiLXfnQa/3DQ9vdJX3WGlc=";
    };
  };
}

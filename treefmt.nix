_: {
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    prettier.enable = true;
    shfmt.enable = true;
    statix.enable = true;
    stylua.enable = true;

    prettier.settings.overrides = [
      {
        files = [
          "*.md"
          "*.mdx"
        ];
        options = {
          proseWrap = "never";
          tabWidth = 4;
        };
      }
    ];
  };

  settings = {
    formatter.statix.priority = -1;

    global.excludes = [
      "flake.lock"
      "*.png"
    ];
  };
}

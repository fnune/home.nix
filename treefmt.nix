{...}: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true;
    stylua.enable = true;
    shfmt.enable = true;
    prettier.enable = true;
  };

  settings.global.excludes = [
    "flake.lock"
    "*.png"
  ];
}

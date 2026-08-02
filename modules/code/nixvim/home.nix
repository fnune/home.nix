{
  pkgs-unstable,
  nixvimPackage,
  ...
}:
{
  home = {
    packages = [
      nixvimPackage
    ]
    ++ (with pkgs-unstable; [
      biome
      gofumpt
      gotools
      imagemagick
      inotify-tools
      nixfmt
      ocamlformat
      prettier
      shellcheck
      shfmt
      sqlite
      sqruff
      stylua
    ]);

    sessionVariables = {
      EDITOR = "${nixvimPackage}/bin/nvim";
      SUDO_EDITOR = "${nixvimPackage}/bin/nvim";
      VISUAL = "${nixvimPackage}/bin/nvim";
    };
  };

  programs.git.settings.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";

  services.pacman.packages = [ "mermaid-cli" ];
}

{
  pkgs-unstable,
  nixvimPackage,
  ...
}: {
  home = {
    packages =
      [nixvimPackage]
      ++ (with pkgs-unstable; [
        alejandra
        biome
        gofumpt
        imagemagick
        inotify-tools
        nodejs_22
        prettier
        shellcheck
        shfmt
        sqlite
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

  services.pacman.packages = ["mermaid-cli"];
}

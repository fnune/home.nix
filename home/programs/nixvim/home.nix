{
  pkgs-unstable,
  nixvimPackage,
  ...
}: {
  home = {
    packages =
      [nixvimPackage]
      ++ (with pkgs-unstable; [
        imagemagick
        inotify-tools
        nodejs_22
        sqlite
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

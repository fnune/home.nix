{
  pkgs,
  config,
  ...
}: let
  neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    extraLuaPackages = ps: [ps.magick];
  };
in {
  home = {
    packages =
      [
        neovim
      ]
      ++ (with pkgs; [
        # LSPs
        angular-language-server
        basedpyright
        bash-language-server
        gopls
        lua-language-server
        nil
        pyright
        rustup
        stylelint-lsp
        taplo
        terraform-ls
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
        # Formatters
        alejandra
        biome
        gofumpt
        nodePackages.prettier
        prettierd
        python3Packages.black
        shfmt
        stylua
        # Debuggers
        delve
        python3Packages.debugpy
        # Lower-level tools
        imagemagick
        inotify-tools
        nodejs_22
        sqlite
        tree-sitter
      ]);

    file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.home.nix/home/programs/neovim/config";

    sessionVariables = {
      EDITOR = "${neovim}/bin/nvim";
      SUDO_EDITOR = "${neovim}/bin/nvim";
      VISUAL = "${neovim}/bin/nvim";
      COLORSCHEME = config.colorscheme;
    };
  };
  programs.git.settings.user.editor = "nvim";
  programs.zsh.shellAliases.vim = "nvim";

  services.pacman.packages = ["mermaid-cli"];
}

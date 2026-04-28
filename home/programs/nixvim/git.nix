{
  pkgs-unstable,
  signs,
  ...
}: {
  extraPlugins = with pkgs-unstable.vimPlugins; [
    nvim-scrollbar
    repolink-nvim
  ];

  plugins = {
    gitsigns = {
      enable = true;
    };
  };

  extraConfigLua = ''
    require("scrollbar").setup({
      set_highlights = true,
      handle = { highlight = "StatusLine" },
      handlers = { cursor = false, gitsigns = true },
      marks = {
        Error = { text = { "${signs.error_single}" } },
        Warn  = { text = { "${signs.warn_single}" } },
        Info  = { text = { "${signs.info_single}" } },
        Hint  = { text = { "${signs.hint_single}" } },
        GitAdd    = { text = "┃" },
        GitChange = { text = "┃" },
        GitDelete = { text = "_" },
      },
    })

    require("repolink").setup({})
  '';
}

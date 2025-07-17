return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.git/.*", "%.cache/.*", "%.yarn/.*" },
          border = false,
          selection_caret = "  ",
          multi_icon = "● ",
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = { "--hidden" },
          },
          buffers = {
            sort_lastused = true,
            mappings = {
              i = {
                ["<c-d>"] = "delete_buffer",
              },
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>f", ":Telescope find_files<CR>", desc = "Find files", silent = true },
      { "<leader>F", ":Telescope live_grep<CR>", desc = "Find text in files", silent = true },
      { "<leader>b", ":Telescope buffers<CR>", desc = "Find buffers", silent = true },
      {
        "<leader>sS",
        ":Telescope lsp_document_symbols<CR>",
        desc = "Find symbols in the document",
        silent = true,
      },
      {
        "<leader>sW",
        ":Telescope lsp_dynamic_workspace_symbols<CR>",
        desc = "Find symbols across the workspace",
        silent = true,
      },
      {
        "<leader>sR",
        ":Telescope resume<CR>",
        desc = "Resume the most recent search",
        silent = true,
      },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      local telescope = require("telescope")
      telescope.load_extension("fzf")
    end,
  },
}

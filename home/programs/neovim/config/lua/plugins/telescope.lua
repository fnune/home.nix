return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    opts = {
      defaults = {
        file_ignore_patterns = { "%.git/.*", "%.cache/.*", "%.yarn/.*" },
        layout_strategy = "vertical",
        layout_config = {
          height = vim.o.lines,
          width = vim.o.columns,
          prompt_position = "bottom",
          preview_height = 0.5,
        },
      },
      pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = { "--hidden" } },
        colorscheme = { enable_preview = true },
      },
    },
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
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
    init = function()
      local telescope = require("telescope")
      telescope.load_extension("fzf")
    end,
  },
}

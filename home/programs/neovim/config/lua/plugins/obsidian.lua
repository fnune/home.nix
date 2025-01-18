return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  event = { "BufReadPre " .. vim.fn.expand("~") .. "/Storage/Vault/*.md" },
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  opts = {
    workspaces = {
      {
        name = "main",
        path = "~/Storage/Vault",
      },
    },
    mappings = {
      ["<C-Space>"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
  },
}

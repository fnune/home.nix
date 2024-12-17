return {
  {
    "nvim-neorg/neorg",
    dependencies = { "nvim-neorg/lua-utils.nvim", "pysan3/pathlib.nvim" },
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.dirman"] = { config = { workspaces = { main = "~/Storage/Neorg" }, default_workspace = "main" } },
          ["core.completion"] = { config = { engine = "nvim-cmp" } },
        },
      })
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function()
          vim.opt_local.foldlevel = 99
          vim.opt_local.conceallevel = 3
        end,
      })
    end,
  },
}

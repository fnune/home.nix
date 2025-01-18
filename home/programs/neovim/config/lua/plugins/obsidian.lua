local vaultpath = vim.fn.expand("~") .. "/Storage/Vault"
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  cmd = { "ObsidianQuickSwitch" },
  event = { "BufReadPre " .. vaultpath .. "/*.md" },
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
  keys = {
    {
      "<leader>N",
      function()
        vim.cmd("vsplit " .. vaultpath .. "/inbox.md")
        vim.cmd("vsplit " .. vaultpath .. "/actions.md")
      end,
      desc = "Open inbox and actions in vertical splits",
    },
  },
}

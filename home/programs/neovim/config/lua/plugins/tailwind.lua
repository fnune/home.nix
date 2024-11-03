return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local tailwind = require("tailwind-tools")

    tailwind.setup({
      document_color = { enabled = false },
      conceal = { enabled = false },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        if vim.lsp.get_client_by_id(args.data.client_id).name == "tailwindcss" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              vim.cmd("TailwindSortSync")
            end,
          })
        end
      end,
    })
  end,
}

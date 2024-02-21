return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "onsails/lspkind.nvim",
  },
  config = function()
    local constants = require("constants")
    local lspkind = require("lspkind")
    local cmp = require("cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = cmp.config.sources(
        -- Group 1: preferable
        {
          { name = "nvim_lsp" },
          { name = "vsnip" },
        },
        -- Group 2: only if group 1 is not available
        {
          { name = "buffer" },
        }
      ),
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<TAB>"] = cmp.mapping.confirm({ select = true }),
      }),
      formatting = { format = lspkind.cmp_format({}) },
      window = {
        completion = {
          border = constants.floating_border,
        },
        documentation = {
          border = constants.floating_border,
        },
      },
      experimental = { ghost_text = true },
    })

    for _, filetype in ipairs({ "gitcommit", "NeogitCommitMessage" }) do
      cmp.setup.filetype(filetype, {
        completion = { autocomplete = false },
        sources = cmp.config.sources({ { name = "buffer" } }),
      })
    end
  end,
}

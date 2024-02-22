return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "lukas-reineke/cmp-under-comparator",
    "onsails/lspkind.nvim",
    "roobert/tailwindcss-colorizer-cmp.nvim",
  },
  config = function()
    local constants = require("constants")
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local cmp_compare_underscore = require("cmp-under-comparator")

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp", group_index = 1 },
        { name = "vsnip", group_index = 1 },
        { name = "buffer", group_index = 2 },
      }),
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp_compare_underscore.under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<TAB>"] = cmp.mapping.confirm({ select = true }),
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          before = function(entry, vim_item)
            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
            return vim_item
          end,
        }),
      },
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

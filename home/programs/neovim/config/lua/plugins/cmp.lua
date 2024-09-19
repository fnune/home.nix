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
    local cmp_window = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
      border = constants.floating_border,
    })

    cmp.setup({
      enabled = function()
        local context = require("cmp.config.context")
        local is_prompt = vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
        local is_comment = context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
        return not (is_prompt or is_comment)
      end,
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      sources = {
        { name = "nvim_lsp", group_index = 1 },
        { name = "vsnip", group_index = 1 },
        { name = "buffer", group_index = 2 },
      },
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
          mode = "symbol",
          before = function(entry, vim_item)
            vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)

            -- Show the source of an auto-importable completion
            local detail = entry.completion_item.detail
            vim_item.menu = detail or ""
            if #vim_item.menu > 20 then
              vim_item.menu = vim_item.menu:sub(1, 20) .. "…"
            end

            return vim_item
          end,
        }),
      },
      window = { completion = cmp_window, documentation = cmp_window },
      experimental = { ghost_text = true },
    })

    for _, filetype in ipairs({ "gitcommit", "NeogitCommitMessage" }) do
      cmp.setup.filetype(filetype, {
        completion = { autocomplete = false },
        sources = cmp.config.sources({ { name = "buffer" } }),
      })
    end

    vim.cmd("hi! link CmpItemMenu Comment")
  end,
}

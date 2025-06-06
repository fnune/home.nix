local function node_type_matches(node_types)
  local success, node = pcall(vim.treesitter.get_node)
  if success and node then
    return vim.tbl_contains(node_types, node:type())
  end
  return false
end

local function is_in_comment()
  return node_type_matches({ "comment", "line_comment", "block_comment" })
end

return {
  { "xzbdmw/colorful-menu.nvim", opts = {} },
  {
    "MattiasMTS/cmp-dbee",
    dependencies = { "kndndrj/nvim-dbee" },
    ft = "sql",
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
      "rafamadriz/friendly-snippets",
      "saghen/blink.compat",
    },
    config = function()
      local blink = require("blink.cmp")

      blink.setup({
        keymap = {
          preset = "super-tab",
          ["<CR>"] = { "accept", "fallback" },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
            scrollbar = false,
          },
        },
        sources = {
          default = function(_)
            if is_in_comment() then
              return { "buffer", "path" }
            end
            return { "lsp", "path", "snippets", "buffer" }
          end,
          per_filetype = {
            codecompanion = { "codecompanion" },
            gitcommit = { "buffer" },
            sql = { "dbee", "lsp", "snippets" },
          },
          providers = {
            dbee = {
              name = "cmp-dbee",
              module = "blink.compat.source",
              opts = {},
            },
          },
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = false,
            },
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = function(ctx)
                return ctx.mode ~= "cmdline"
              end,
            },
          },
          menu = {
            draw = {
              columns = { { "kind_icon" }, { "label", gap = 1 } },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
            scrollbar = false,
            auto_show = function(_)
              return not (
                is_in_comment()
                or vim.bo.filetype == "AvanteInput"
                or vim.bo.filetype == "gitcommit"
                or vim.bo.filetype == "markdown"
              )
            end,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 150,
            window = { scrollbar = false },
          },
          ghost_text = {
            enabled = true,
          },
        },
      })
    end,
  },
}

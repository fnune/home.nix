local constants = require("constants")

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
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets", "kristijanhusak/vim-dadbod-completion" },
    config = function()
      local blink = require("blink.cmp")

      blink.setup({
        keymap = {
          preset = "super-tab",
          ["<CR>"] = { "accept", "fallback" },
          cmdline = { preset = "super-tab" },
        },
        signature = {
          enabled = true,
          window = {
            show_documentation = true,
            border = constants.floating_border,
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
            sql = { "dadbod", "lsp", "snippets" },
          },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
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
            border = constants.floating_border,
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
                or vim.bo.filetype == "DressingInput"
                or vim.bo.filetype == "gitcommit"
                or vim.bo.filetype == "markdown"
              )
            end,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 150,
            window = { border = constants.floating_border, scrollbar = false },
          },
          ghost_text = {
            enabled = true,
          },
        },
      })

      vim.cmd([[
        hi! link BlinkCmpMenuBorder FloatBorder
        hi! link BlinkCmpDocBorder FloatBorder
        hi! link BlinkCmpSignatureHelpBorder FloatBorder
        hi! link BlinkCmpGhostText Conceal
      ]])
    end,
  },
}

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      checkbox = { checked = { icon = "" }, unchecked = { icon = "󰄱" } },
      code = { style = "normal", border = "thin", above = "─", below = "─" },
      heading = { enabled = false },
      indent = { enabled = false },
      pipe_table = { style = "normal" },
      sign = { enabled = false },
      file_types = { "markdown" },
      latex = { enabled = false },
      overrides = {
        buftype = {
          nofile = {
            code = { border = "hide" },
          },
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
  },
  {
    "YousefHadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {},
    keys = function()
      local notes_dir = "~/Documents/Fausto/daily/"
      local function open_daily_note(offset)
        return function()
          local date = os.date("%Y-%m-%d", os.time() + offset * 86400)
          local path = vim.fn.expand(notes_dir .. date .. ".md")
          vim.cmd("edit " .. path)
        end
      end

      return {
        { "<leader>on", open_daily_note(0), desc = "Open today's note" },
        { "<leader>ot", open_daily_note(1), desc = "Open tomorrow's note" },
        { "<leader>oy", open_daily_note(-1), desc = "Open yesterday's note" },
      }
    end,
  },
}

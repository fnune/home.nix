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
      local notes_dir = vim.env.NOTES_DIR .. "/daily/"
      local function open_daily_note(offset)
        return function()
          local timestamp = os.time() + offset * 86400
          local date = os.date("%Y-%m-%d", timestamp)
          local path = vim.fn.expand(notes_dir .. date .. ".md")

          vim.cmd("edit " .. path)

          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local is_empty = #lines == 1 and lines[1] == ""

          if is_empty then
            local heading = os.date("# %B %d, %Y", timestamp)
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { heading, "", "" })
            vim.api.nvim_win_set_cursor(0, { 3, 0 })
            vim.cmd("startinsert")
          end
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

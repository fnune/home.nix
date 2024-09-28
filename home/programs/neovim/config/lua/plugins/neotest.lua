local function prompt_args()
  local args = {}
  for arg in string.gmatch(vim.fn.input("Extra arguments: "), "[^%s]+") do
    table.insert(args, arg)
  end
  return args
end

return {
  { "folke/neodev.nvim", opts = { library = { plugins = { "neotest" }, types = true } }, priority = 51 },
  { "marilari88/neotest-vitest", lazy = true },
  { "nvim-neotest/neotest-jest", lazy = true },
  { "nvim-neotest/neotest-python", lazy = true },
  { "rouge8/neotest-rust", lazy = true },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
      "rouge8/neotest-rust",
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-jest")({}),
          require("neotest-python")({}),
          require("neotest-rust")({}),
          require("neotest-vitest")({}),
        },
        discovery = { enabled = false },
        quickfix = { open = false },
        output = { open_on_run = false },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neotest-summary",
        callback = function()
          vim.wo.wrap = false
        end,
      })
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle tests summary",
        silent = true,
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run()
        end,
        desc = "Run the closest test",
        silent = true,
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run all tests",
        silent = true,
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.run({ extra_args = require("neotest").utils.prompt_args() })
        end,
        desc = "Run the closest test with extra arguments",
        silent = true,
      },
      {
        "<leader>tuS",
        function()
          require("neotest").run.run({ extra_args = { "--snapshot-update" } })
        end,
        desc = "Run the closest test with --snapshot-update",
        silent = true,
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), extra_args = prompt_args() })
        end,
        desc = "Run all tests with extra arguments",
        silent = true,
      },
      {
        "<leader>tuA",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), extra_args = { "--snapshot-update" } })
        end,
        desc = "Run all tests with --snapshot-update",
        silent = true,
      },
      {
        "<leader>ds",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug the closest test",
        silent = true,
      },
      {
        "<leader>dS",
        function()
          require("neotest").run.run({ strategy = "dap", extra_args = prompt_args() })
        end,
        desc = "Debug the closest test with extra arguments",
        silent = true,
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle the test output panel",
        silent = true,
      },
    },
  },
}

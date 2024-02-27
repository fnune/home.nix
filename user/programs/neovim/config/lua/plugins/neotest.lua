return {
  { "nvim-neotest/neotest-jest", lazy = true },
  { "nvim-neotest/neotest-python", lazy = true },
  { "rouge8/neotest-rust", lazy = true },
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-jest")({}),
          require("neotest-python")({}),
          require("neotest-rust")({}),
        },
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
    init = function()
      local neotest = require("neotest")
      local m = require("mapx")

      local function prompt_args()
        local args = {}
        for arg in string.gmatch(vim.fn.input("Extra arguments: "), "[^%s]+") do
          table.insert(args, arg)
        end
        return args
      end

      m.nname("<leader>t", "Tests")
      m.nname("<leader>tu", "Run with --snapshot-update")

      m.nmap("<leader>ts", function()
        neotest.run.run()
      end, { silent = true }, "Run the closest test")

      m.nmap("<leader>ta", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { silent = true }, "Run all tests")

      m.nmap("<leader>tS", function()
        neotest.run.run({ extra_args = prompt_args() })
      end, { silent = true }, "Run the closest test with extra arguments")

      m.nmap("<leader>tuS", function()
        neotest.run.run({ extra_args = { "--snapshot-update" } })
      end, { silent = true }, "Run the closest test with --snapshot-update")

      m.nmap("<leader>tA", function()
        neotest.run.run({ vim.fn.expand("%"), extra_args = prompt_args() })
      end, { silent = true }, "Run all tests with extra arguments")

      m.nmap("<leader>tuA", function()
        neotest.run.run({ vim.fn.expand("%"), extra_args = { "--snapshot-update" } })
      end, { silent = true }, "Run all tests with --snapshot-update")

      m.nmap("<leader>ds", function()
        neotest.run.run({ strategy = "dap" })
      end, { silent = true }, "Debug the closest test")

      m.nmap("<leader>dS", function()
        neotest.run.run({ strategy = "dap", extra_args = prompt_args() })
      end, { silent = true }, "Debug the closest test with extra arguments")

      m.nmap("<leader>to", function()
        neotest.output_panel.toggle()
      end, { silent = true }, "Toggle the test output panel")
    end,
  },
}

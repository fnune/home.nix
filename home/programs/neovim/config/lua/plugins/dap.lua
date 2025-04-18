return {
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    init = function()
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "󰟃 ", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = " ", texthl = "DiagnosticHint", linehl = "CursorLine", numhl = "CursorLine" }
      )
    end,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Add a conditional breakpoint",
      },
      {
        "<leader>dm",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log-point message: "))
        end,
        desc = "Add a log-point message",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Show value",
      },
      {
        "<leader>dp",
        function()
          require("dap.ui.widgets").preview()
        end,
        desc = "Preview value",
      },
      {
        "<F1>",
        function()
          require("dap").disconnect()
        end,
        desc = "Debugger: disconnect",
      },
      {
        "<F4>",
        function()
          require("dap").run_last()
        end,
        desc = "Debugger: run last",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debugger: continue",
      },
      {
        "<F6>",
        function()
          require("dap").pause()
        end,
        desc = "Debugger: pause",
      },
      {
        "<F7>",
        function()
          require("dap").terminate()
        end,
        desc = "Debugger: terminate",
      },
      {
        "<F9>",
        function()
          require("dap").step_back()
        end,
        desc = "Debugger: step back",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debugger: step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debugger: step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debugger: step out",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    version = false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = " F1",
          play = " F5",
          pause = " F6",
          terminate = " F7",
          run_last = " F4",
          step_back = " F9",
          step_over = " F10",
          step_into = " F11",
          step_out = " F12",
        },
      },
    },
    init = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end

      vim.api.nvim_create_autocmd("ExitPre", {
        nested = true,
        callback = function()
          dapui.close()
        end,
      })
    end,
    keys = {
      {
        "<leader>dd",
        function()
          require("dapui").toggle({ reset = true })
        end,
        desc = "Toggle debugging view",
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("python")
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "microsoft/vscode-js-debug",
    build = [[
      npm install --legacy-peer-deps --ignore-scripts --no-package-lock
      npx gulp vsDebugServerBundle
      mv dist out
    ]],
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require("dap")
      local dap_vscode_js = require("dap-vscode-js")

      dap_vscode_js.setup({
        debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
        adapters = { "pwa-node", "pwa-chrome" },
      })

      for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "󰎙 Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "󰊯 Launch Chrome & debug",
            url = "http://localhost:8000",
            webRoot = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = " Attach to a running process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}

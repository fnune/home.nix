return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local m = require("mapx")
      local lspconfig = require("lspconfig")

      local cmp_lsp = require("cmp_nvim_lsp")

      local lsp_capabilities = cmp_lsp.default_capabilities()
      local lsp_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        m.nmap("K", function()
          vim.lsp.buf.hover()
        end, bufopts, "Show documentation")
        m.nmap("<leader>k", function()
          vim.diagnostic.goto_prev()
        end, "Previous diagnostic")
        m.nmap("<leader>j", function()
          vim.diagnostic.goto_next()
        end, "Next diagnostic")
        m.nmap("<leader>r", function()
          vim.lsp.buf.rename()
        end, bufopts, "Rename symbol")

        m.nname("g", "Go to")
        m.nmap("gD", function()
          vim.lsp.buf.declaration()
        end, bufopts, "Go to declaration")
        m.nmap("gd", function()
          vim.lsp.buf.definition()
        end, bufopts, "Go to definition")
        m.nmap("gr", function()
          vim.lsp.buf.references()
        end, bufopts, "Show references")

        m.nname("a", "Code actions")
        m.nmap("<leader>ac", function()
          vim.lsp.buf.code_action()
        end, "Apply code action (normal)")
        m.xmap("<leader>ac", function()
          vim.lsp.buf.code_action()
        end, "Apply code action (visual)")
      end

      local common = {
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
      }

      lspconfig.clangd.setup(common)
      lspconfig.eslint.setup(common)
      lspconfig.gdscript.setup(common)
      lspconfig.jsonls.setup(common)
      lspconfig.lua_ls.setup(common)
      lspconfig.nil_ls.setup(common)
      lspconfig.pyright.setup(common)
      lspconfig.ruff_lsp.setup(common)
      lspconfig.rust_analyzer.setup(common)
      lspconfig.taplo.setup(common)
      lspconfig.yamlls.setup(common)

      lspconfig.tsserver.setup(vim.tbl_deep_extend("force", common, {
        init_options = {
          hostInfo = "neovim",
          preferences = { importModuleSpecifierPreference = "non-relative" },
        },
        handlers = {
          ["textDocument/formatting"] = function()
            -- noop: let prettier do this
          end,
        },
      }))

      lspconfig.jsonls.setup(vim.tbl_deep_extend("force", common, {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
      }))

      lspconfig.yamlls.setup(vim.tbl_deep_extend("force", common, {
        settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
      }))

      lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", common, {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      }))

      lspconfig.pyright.setup(vim.tbl_deep_extend("force", common, {
        root_dir = function()
          return vim.fn.getcwd()
        end,
        handlers = {
          ["textDocument/publishDiagnostics"] = function()
            -- noop: I get enough diagnostics from Ruff and mypy.
          end,
        },
        settings = {
          python = {
            analysis = {
              diagnosticMode = "off",
              typeCheckingMode = "off",
            },
          },
        },
      }))

      local constants = require("constants")
      local handlers = vim.lsp.handlers
      handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = constants.floating_border })
      handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = constants.floating_border })
      vim.diagnostic.config({ float = { border = constants.floating_border } })

      local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },
}

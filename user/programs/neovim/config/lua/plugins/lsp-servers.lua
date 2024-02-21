return {
  "neovim/nvim-lspconfig",
  dependencies = { "b0o/SchemaStore.nvim", "hrsh7th/cmp-nvim-lsp" },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_lsp = require("cmp_nvim_lsp")

    local common = { capabilities = cmp_lsp.default_capabilities() }

    lspconfig.clangd.setup(common)
    lspconfig.eslint.setup(common)
    lspconfig.gdscript.setup(common)
    lspconfig.jsonls.setup(common)
    lspconfig.lua_ls.setup(common)
    lspconfig.nil_ls.setup(common)
    lspconfig.pyright.setup(common)
    lspconfig.ruff_lsp.setup(common)
    lspconfig.rust_analyzer.setup(common)
    lspconfig.tailwindcss.setup(common)
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
      on_attach = function(client, _)
        if require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
          client.stop()
        end
      end,
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
    }))

    lspconfig.denols.setup(vim.tbl_deep_extend("force", common, {
      on_attach = function(_, _)
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          if client.name == "tsserver" then
            client.stop()
          end
        end
      end,
    }))
  end,
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", "saghen/blink.cmp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local function setup(lsp, opts)
        lspconfig[lsp].setup(vim.tbl_deep_extend("force", { capabilities = capabilities }, opts))
      end

      setup("angularls", {})
      setup("biome", {})
      setup("clangd", {})
      setup("gdscript", {})
      setup("ocamllsp", {})
      setup("ruff", {})
      setup("rust_analyzer", {})
      setup("stylelint_lsp", {})
      setup("taplo", {})
      setup("terraformls", {})
      setup("vtsls", {})

      setup("nil_ls", {
        init_options = { nix = { flake = { autoArchive = true } } },
      })

      setup("jsonls", {
        init_options = { provideFormatter = false },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      setup("basedpyright", {})

      setup("yamlls", {
        settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
      })

      setup("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
    end,
  },
}

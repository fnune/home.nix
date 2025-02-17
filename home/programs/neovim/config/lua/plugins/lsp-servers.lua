return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local server = require("typescript-tools")
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      server.setup({
        capabilities = capabilities,
        settings = { expose_as_code_action = "all" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", "saghen/blink.cmp" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local function setup(lsp, opts)
        lspconfig[lsp].setup(vim.tbl_deep_extend("force", { capabilities = capabilities }, opts))
      end

      setup("biome", {})
      setup("clangd", {})
      setup("gdscript", {})
      setup("ocamllsp", {})
      setup("ruff", {})
      setup("rust_analyzer", {})
      setup("stylelint_lsp", {})
      setup("taplo", {})
      setup("terraformls", {})

      setup("nil_ls", {
        init_options = { nix = { flake = { autoArchive = true } } },
      })

      setup("jsonls", {
        settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
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

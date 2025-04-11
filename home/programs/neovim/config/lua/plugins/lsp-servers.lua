local function setup(lsp, opts)
  require("lspconfig")[lsp].setup(opts)
end

local function with_defaults(server_opts)
  local capabilities_blink = require("blink.cmp").get_lsp_capabilities()
  local capabilities_common = { general = { positionEncodings = { "utf-16" } } }
  local capabilities = vim.tbl_deep_extend("force", capabilities_blink, capabilities_common)
  return vim.tbl_deep_extend("force", { capabilities = capabilities }, server_opts)
end

return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local server = require("typescript-tools")
      server.setup(with_defaults({ settings = { expose_as_code_action = "all" } }))
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", "saghen/blink.cmp" },
    config = function()
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

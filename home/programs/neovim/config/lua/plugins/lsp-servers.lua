return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")

      local function setup(lsp, opts)
        lspconfig[lsp].setup(vim.tbl_deep_extend("force", {
          capabilities = cmp_lsp.default_capabilities(),
        }, opts))
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

      setup("pyright", {
        root_dir = function()
          return vim.fn.getcwd()
        end,
      })

      setup("yamlls", {
        settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
      })

      setup("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
    end,
  },
}

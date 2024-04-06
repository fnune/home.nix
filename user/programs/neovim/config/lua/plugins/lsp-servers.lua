return {
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

    setup("clangd", {})
    setup("eslint", {})
    setup("gdscript", {})
    setup("jsonls", {})
    setup("lua_ls", {})
    setup("pyright", {})
    setup("ruff_lsp", {})
    setup("rust_analyzer", {})
    setup("tailwindcss", {})
    setup("taplo", {})
    setup("yamlls", {})

    setup("nil_ls", {
      init_options = { nix = { flake = { autoArchive = true } } },
    })

    setup("tsserver", {
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
        if lspconfig.util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
          client.stop()
        end
      end,
    })

    setup("jsonls", {
      settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
    })

    setup("yamlls", {
      settings = { yaml = { schemas = require("schemastore").yaml.schemas() } },
    })

    setup("lua_ls", {
      settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    })

    setup("pyright", {
      root_dir = function()
        return vim.fn.getcwd()
      end,
    })

    setup("denols", {
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      on_attach = function(_, _)
        for _, client in ipairs(vim.lsp.get_active_clients()) do
          if client.name == "tsserver" then
            client.stop()
          end
        end
      end,
    })
  end,
}

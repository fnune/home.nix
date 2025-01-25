return {
  { "NoahTheDuke/vim-just", ft = { "just" } },
  { "nvim-treesitter/nvim-treesitter-textobjects", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local treesitter_configs = require("nvim-treesitter.configs")

      treesitter_configs.setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["am"] = { query = "@function.outer", desc = "a function or method" },
              ["im"] = { query = "@function.inner", desc = "inner function or method" },
              ["af"] = { query = "@call.outer", desc = "a function or method call" },
              ["if"] = { query = "@call.inner", desc = "inner function or method call" },
              ["ac"] = { query = "@class.outer", desc = "a class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["ai"] = { query = "@conditional.outer", desc = "a conditional" },
              ["ii"] = { query = "@conditional.inner", desc = "inner conditional" },
              ["al"] = { query = "@loop.outer", desc = "a loop" },
              ["il"] = { query = "@loop.inner", desc = "inner loop" },
              ["ar"] = { query = "@return.outer", desc = "a return statement" },
              ["ir"] = { query = "@return.inner", desc = "inner return statement" },
              ["a="] = { query = "@assignment.lhs", desc = "an assignment's left-hand side" },
              ["i="] = { query = "@assignment.rhs", desc = "an assignment's right-hand side" },
            },
            selection_modes = {
              ["@class.outer"] = "V",
              ["@conditional.outer"] = "V",
              ["@function.outer"] = "V",
              ["@loop.outer"] = "V",
            },
          },
        },
        ensure_installed = {
          "arduino",
          "awk",
          "bash",
          "bibtex",
          "c",
          "c_sharp",
          "clojure",
          "cmake",
          "comment",
          "commonlisp",
          "cpp",
          "css",
          "dart",
          "devicetree",
          "diff",
          "dockerfile",
          "dot",
          "eex",
          "elixir",
          "elm",
          "erlang",
          "fish",
          "fortran",
          "gdscript",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "godot_resource",
          "gomod",
          "gosum",
          "gowork",
          "graphql",
          "haskell",
          "hcl",
          "html",
          "htmldjango",
          "http",
          "ini",
          "java",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "julia",
          "kdl",
          "kotlin",
          "latex",
          "llvm",
          "lua",
          "luadoc",
          "luap",
          "luau",
          "make",
          "markdown",
          "markdown_inline",
          "matlab",
          "mermaid",
          "meson",
          "ninja",
          "nix",
          "norg",
          "objc",
          "ocaml",
          "ocaml_interface",
          "org",
          "pascal",
          "passwd",
          "perl",
          "php",
          "phpdoc",
          "prisma",
          "proto",
          "pug",
          "python",
          "query",
          "r",
          "racket",
          "regex",
          "rst",
          "ruby",
          "rust",
          "scala",
          "scheme",
          "scss",
          "sparql",
          "sql",
          "svelte",
          "sxhkdrc",
          "terraform",
          "tlaplus",
          "todotxt",
          "toml",
          "tsx",
          "typescript",
          "vala",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
          "zig",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}

local parsers = {
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
  "objc",
  "ocaml",
  "ocaml_interface",
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
  "typst",
  "vala",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
  "zig",
}

return {
  { "NoahTheDuke/vim-just", ft = { "just" } },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@class.outer"] = "V",
            ["@conditional.outer"] = "V",
            ["@function.outer"] = "V",
            ["@loop.outer"] = "V",
          },
        },
      })

      local select_to = require("nvim-treesitter-textobjects.select")
      local keymaps = {
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
      }

      for key, opts in pairs(keymaps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select_to.select_textobject(opts.query, "textobjects")
        end, { desc = opts.desc })
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.keymap.set("n", "<M-o>", "van", { desc = "Start incremental node selection" })
      vim.keymap.set("x", "<M-o>", "an", { desc = "Expand selection to parent node" })
      vim.keymap.set("x", "<M-i>", "in", { desc = "Shrink selection to child node" })
    end,
  },
}

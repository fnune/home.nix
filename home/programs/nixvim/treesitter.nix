{
  config,
  raw,
  ...
}: let
  parsers = with config.plugins.treesitter.package.builtGrammars; [
    arduino
    awk
    bash
    bibtex
    c
    c-sharp
    clojure
    cmake
    comment
    commonlisp
    cpp
    css
    dart
    devicetree
    diff
    dockerfile
    dot
    eex
    elixir
    elm
    erlang
    fish
    fortran
    gdscript
    git_config
    git_rebase
    gitattributes
    gitcommit
    gitignore
    go
    godot-resource
    gomod
    gosum
    gowork
    graphql
    haskell
    hcl
    html
    htmldjango
    http
    ini
    java
    javascript
    jq
    jsdoc
    json
    json5
    julia
    kdl
    kotlin
    latex
    llvm
    lua
    luadoc
    luap
    luau
    make
    markdown
    markdown_inline
    matlab
    mermaid
    meson
    ninja
    nix
    objc
    ocaml
    ocaml_interface
    pascal
    passwd
    perl
    php
    phpdoc
    prisma
    proto
    pug
    python
    query
    r
    racket
    regex
    rst
    ruby
    rust
    scala
    scheme
    scss
    sparql
    sql
    svelte
    sxhkdrc
    terraform
    tlaplus
    todotxt
    toml
    tsx
    typescript
    typst
    vala
    vim
    vimdoc
    vue
    yaml
    zig
  ];
in {
  plugins = {
    treesitter = {
      enable = true;
      grammarPackages = parsers;
      highlight.enable = true;
      indent.enable = true;
      languageRegister.lua = "p8lua";
    };

    treesitter-textobjects = {
      enable = true;
    };
  };

  extraConfigLua = ''
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

    do
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
    end
  '';

  keymaps = [
    {
      mode = "n";
      key = "<M-o>";
      action = "van";
      options.desc = "Start incremental node selection";
    }
    {
      mode = "x";
      key = "<M-o>";
      action = "an";
      options.desc = "Expand selection to parent node";
    }
    {
      mode = "x";
      key = "<M-i>";
      action = "in";
      options.desc = "Shrink selection to child node";
    }
  ];
}

{
  pkgs-unstable,
  file_explorer_width_chars,
  raw,
  ...
}: {
  extraPlugins = with pkgs-unstable.vimPlugins; [
    nvim-lsp-file-operations
  ];

  extraConfigLua = ''
    require("lsp-file-operations").setup({})
  '';

  plugins = {
    nvim-tree = {
      enable = true;
      settings = {
        view.width = file_explorer_width_chars;
        diagnostics.enable = false;
        renderer.group_empty = true;
        disable_netrw = true;
      };
    };

    oil = {
      enable = true;
      settings = {};
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = ":NvimTreeToggle<cr>";
      options = {
        desc = "Toggle the file explorer view";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = ":NvimTreeFindFile<cr>";
      options = {
        desc = "Find the current file in the explorer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>O";
      action = raw ''
        function()
          if vim.bo.filetype == "oil" then
            require("oil").close()
          else
            require("oil").open()
          end
        end
      '';
      options = {
        desc = "Toggle the directory explorer view";
        silent = true;
      };
    }
  ];
}

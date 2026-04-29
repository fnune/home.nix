{
  pkgs-unstable,
  customPlugins,
  lib,
  ...
}: {
  extraPlugins = [customPlugins.markdown-plus-nvim];

  plugins = {
    todo-comments = {
      enable = true;
      settings.signs = false;
    };

    render-markdown = {
      enable = true;
      settings = {
        checkbox = {
          checked.icon = "";
          unchecked.icon = "󰄱";
        };
        code = {
          style = "normal";
          border = "thin";
          above = "─";
          below = "─";
        };
        heading.enabled = false;
        indent.enabled = false;
        pipe_table.style = "normal";
        sign.enabled = false;
        file_types = ["markdown"];
        latex.enabled = false;
        overrides.buftype.nofile.code.border = "hide";
      };
    };
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "markdown";
      callback = lib.nixvim.mkRaw ''
        function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.wrap = true
        end
      '';
    }
  ];

  extraConfigLua = ''
    require("markdown-plus").setup({})
  '';

  keymaps = let
    daily_note = offset: ''
      function()
        local notes_dir = vim.env.NOTES_DIR .. "/daily/"
        local timestamp = os.time() + (${toString offset}) * 86400
        local date = os.date("%Y-%m-%d", timestamp)
        local path = vim.fn.expand(notes_dir .. date .. ".md")

        vim.cmd("edit " .. path)

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local is_empty = #lines == 1 and lines[1] == ""

        if is_empty then
          local heading = os.date("# %B %d, %Y", timestamp)
          vim.api.nvim_buf_set_lines(0, 0, 0, false, { heading, "", "" })
          vim.api.nvim_win_set_cursor(0, { 3, 0 })
          vim.cmd("startinsert")
        end
      end
    '';
  in [
    {
      mode = "n";
      key = "<leader>on";
      action = lib.nixvim.mkRaw (daily_note 0);
      options.desc = "Open today's note";
    }
    {
      mode = "n";
      key = "<leader>ot";
      action = lib.nixvim.mkRaw (daily_note 1);
      options.desc = "Open tomorrow's note";
    }
    {
      mode = "n";
      key = "<leader>oy";
      action = lib.nixvim.mkRaw (daily_note (-1));
      options.desc = "Open yesterday's note";
    }
  ];
}

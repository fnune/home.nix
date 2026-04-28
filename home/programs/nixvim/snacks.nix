{raw, ...}: {
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      image.enabled = true;
      input.enabled = true;
      notifier.enabled = true;
      picker = {
        enabled = true;
        layout.preset = "ivy";
      };
      quickfile.enabled = true;
      styles.zen.backdrop = {
        blend = 0;
        transparent = false;
      };
      zen = {
        enabled = true;
        toggles.dim = false;
      };
      dashboard.enabled = false;
      dim.enabled = false;
      explorer.enabled = false;
      lazygit.enabled = false;
      scope.enabled = false;
      scroll.enabled = false;
      statuscolumn.enabled = false;
      words.enabled = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>f";
      action = raw "function() require('snacks').picker.smart() end";
      options = {
        desc = "Find files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>F";
      action = raw "function() require('snacks').picker.grep() end";
      options = {
        desc = "Find text in files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>b";
      action = raw "function() require('snacks').picker.buffers() end";
      options = {
        desc = "Find buffers";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sS";
      action = raw "function() require('snacks').picker.lsp_symbols() end";
      options = {
        desc = "Find symbols in the document";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sW";
      action = raw "function() require('snacks').picker.lsp_workspace_symbols() end";
      options = {
        desc = "Find symbols across the workspace";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sR";
      action = raw "function() require('snacks').picker.resume() end";
      options = {
        desc = "Resume the most recent search";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>z";
      action = raw "function() require('snacks').zen() end";
      options = {
        desc = "Toggle zen mode";
        silent = true;
      };
    }
  ];
}

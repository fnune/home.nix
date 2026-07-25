{
  customPlugins,
  lib,
  ...
}: {
  extraPlugins = [customPlugins.standard];

  colorscheme = "standard";

  plugins = {
    web-devicons = {
      enable = true;
    };

    tiny-devicons-auto-colors = {
      enable = true;
      settings.colors = lib.nixvim.mkRaw "vim.tbl_values(require('standard.palette').tokens)";
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          component_separators = {
            left = "│";
            right = "│";
          };
          globalstatus = true;
          section_separators = {
            left = "";
            right = "";
          };
          theme = "auto";
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch" "diff" "diagnostics"];
          lualine_c = [
            {
              __unkeyed-1 = "filename";
              path = 1;
            }
          ];
          lualine_x = ["filetype"];
          lualine_y = ["progress"];
          lualine_z = ["location"];
        };
      };
    };
  };
}

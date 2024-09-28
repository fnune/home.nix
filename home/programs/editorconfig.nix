_: {
  editorconfig.enable = true;
  editorconfig.settings = {
    "*" = {
      charset = "utf-8";
      end_of_line = "lf";
      indent_size = 2;
      indent_style = "space";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
    "*.rs" = {
      indent_size = 4;
    };
  };
}

{config, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {size = 15.25;};
      scrolling = {history = 100000;};
      window = {
        decorations = "None";
        startup_mode = "Maximized";
      };
      shell = {
        program = config.shell.bin;
        args = config.shell.args;
      };
      import = ["${config.home.homeDirectory}/Development/vscode.nvim/extra/alacritty/alacritty.yml"];
    };
  };
}

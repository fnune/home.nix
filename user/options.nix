{
  lib,
  pkgs,
  config,
  ...
}: {
  config.home.sessionVariables = {
    COLORSCHEME = config.colorscheme;
  };

  options = {
    machine = {
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
        description = "The display scaling that this machine uses on its primary monitor";
      };
    };
    colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "vscode";
      description = "The preferred colorscheme for the terminal, Neovim and others";
    };
    shell = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "zsh";
        description = "The default shell name";
      };
      bin = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.zsh}/bin/zsh";
        description = "The default shell binary path";
      };
      args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["--login"];
        description = "The list of arguments to pass to the terminal emulator command";
      };
    };
    terminal = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        description = "The preferred terminal emulator name";
      };
      bin = lib.mkOption {
        type = lib.types.path;
        default = "${pkgs.unstable.kitty}/bin/kitty";
        description = "The full path to the terminal emulator binary";
      };
    };
  };
}

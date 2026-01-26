{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    profile = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Fausto Núñez Alberro";
      };
      email = {
        personal = lib.mkOption {
          type = lib.types.str;
          default = "fausto.nunez@mailbox.org";
        };
      };
      sshKeyPath = lib.mkOption {
        type = lib.types.str;
        default = "${config.home.homeDirectory}/.ssh/id_ed25519";
        description = "Full path to the SSH private key";
      };
    };
    machine = {
      scale = lib.mkOption {
        type = lib.types.float;
        default = 1.7;
        description = "The display scaling that this machine uses on its primary monitor";
      };
    };
    # See https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
    fontconfig = {
      sans = lib.mkOption {
        type = lib.types.str;
        default = "Inter";
        description = "Sans font to use for the desktop";
      };
      serif = lib.mkOption {
        type = lib.types.str;
        default = "Libre Baskerville";
        description = "Serif font to use for the desktop";
      };
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrains Mono";
        description = "Monospace font to use for the desktop and terminal";
      };
      cjkSans = lib.mkOption {
        type = lib.types.str;
        default = "Noto Sans CJK JP";
        description = "CJK sans-serif fallback font";
      };
      cjkSerif = lib.mkOption {
        type = lib.types.str;
        default = "Noto Serif CJK JP";
        description = "CJK serif fallback font";
      };
      cjkMono = lib.mkOption {
        type = lib.types.str;
        default = "Noto Sans Mono CJK JP";
        description = "CJK monospace fallback font";
      };
      emoji = lib.mkOption {
        type = lib.types.str;
        default = "Noto Color Emoji";
        description = "Emoji font to use for the desktop and terminal";
      };
      subpixel = lib.mkOption {
        type = lib.types.str;
        default = "rgb";
        description = "Subpixel rendering method: 'none', 'rgb', 'bgr', 'vrgb', 'vbgr'";
      };
      hinting = lib.mkOption {
        type = lib.types.str;
        default = "hintslight";
        description = "Hinting: 'hintnone', 'hintslight', 'hintmedium', 'hintfull'";
      };
      antialias = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Antialiasing";
      };
    };
    colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "standard";
      description = "The preferred colorscheme for the terminal, Neovim and others";
    };
    accent = {
      rgb = lib.mkOption {
        type = lib.types.str;
        default = "31,118,255";
      };
    };
    panel = {
      height = lib.mkOption {
        type = lib.types.int;
        default = 44;
        description = "Height of the desktop environment panel";
      };
    };
    cursors = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "breeze_cursors";
        description = "The name of the cursor theme";
      };
      size = lib.mkOption {
        type = lib.types.int;
        default = 32;
        description = "The size of the cursor";
      };
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
        default = "${pkgs.kittyWithWhiskers}/bin/kitty";
        description = "The full path to the terminal emulator binary";
      };
    };
    browser = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "firefox";
        description = "The preferred browser";
      };
    };
  };
}

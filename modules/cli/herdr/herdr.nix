{
  pkgs,
  pkgs-unstable,
  vimHerdrNavigation,
  standard,
  config,
  lib,
  options,
  ...
}:
let
  colorschemeConf = builtins.readFile "${standard}/herdr/standard.dark.toml";

  loginShell = pkgs.writeShellScript "herdr-login-shell" ''
    exec ${config.shell.bin} ${lib.escapeShellArgs config.shell.args} "$@"
  '';

  tinyFingers = pkgs-unstable.rustPlatform.buildRustPackage {
    pname = "herdr-tiny-fingers";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "hotchpotch";
      repo = "herdr-tiny-fingers";
      rev = "3107e5d3547ab23b064f13576508bbd68186cf57";
      hash = "sha256-q+ZE7KyHw+8KhOyxxYWGxSno2vlluiHfU/uur5Db+iQ=";
    };
    cargoHash = "sha256-bGsLgaeD/8m/OhFp4NfrwgdZFtyJna67eB2XSWyHwyU=";
    postInstall = ''
      cp herdr-plugin.toml $out/
      mkdir -p $out/target/release
      ln -s $out/bin/herdr-tiny-fingers $out/target/release/
    '';
  };
  tinyFingersBin = "./target/release/herdr-tiny-fingers";

  navigationActions = [
    {
      id = "left";
      title = "Navigate left (Vim/herdr)";
      contexts = [ "global" ];
      command = [
        "bash"
        "navigate.sh"
        "left"
      ];
    }
    {
      id = "down";
      title = "Navigate down (Vim/herdr)";
      contexts = [ "global" ];
      command = [
        "bash"
        "navigate.sh"
        "down"
      ];
    }
    {
      id = "up";
      title = "Navigate up (Vim/herdr)";
      contexts = [ "global" ];
      command = [
        "bash"
        "navigate.sh"
        "up"
      ];
    }
    {
      id = "right";
      title = "Navigate right (Vim/herdr)";
      contexts = [ "global" ];
      command = [
        "bash"
        "navigate.sh"
        "right"
      ];
    }
  ];

  # herdr writes this registry itself when you run `herdr plugin link`, which
  # would leave the plugin pinned to whatever revision was linked by hand.
  # It reads the file happily when it is a read-only store symlink, so declare
  # it here instead and let the store path carry the version.
  pluginRegistry = [
    {
      plugin_id = "vim-herdr-navigation";
      name = "Vim Herdr Navigation";
      version = "0.1.0";
      min_herdr_version = "0.7.0";
      description = "Seamless Ctrl+h/j/k/l navigation across herdr panes and Vim/Neovim splits";
      manifest_path = "${vimHerdrNavigation}/herdr-plugin.toml";
      plugin_root = "${vimHerdrNavigation}";
      enabled = true;
      platforms = [
        "linux"
        "macos"
      ];
      actions = navigationActions;
      source.kind = "local";
    }
    {
      plugin_id = "hotchpotch.herdr-tiny-fingers";
      name = "herdr-tiny-fingers";
      inherit (tinyFingers) version;
      min_herdr_version = "0.7.0";
      description = "tmux-fingers style visible-screen copy hints for Herdr";
      manifest_path = "${tinyFingers}/herdr-plugin.toml";
      plugin_root = "${tinyFingers}";
      enabled = true;
      platforms = [
        "linux"
        "macos"
      ];
      actions = [
        {
          id = "open";
          title = "Open fingers mode";
          description = "Open tmux-fingers style copy hints for the focused pane";
          command = [
            tinyFingersBin
            "open"
          ];
        }
      ];
      panes = [
        {
          id = "finger";
          title = "herdr-tiny-fingers";
          placement = "overlay";
          command = [ tinyFingersBin ];
        }
      ];
      source.kind = "local";
    }
  ];

  navigationKeys =
    lib.concatMapStrings
      (direction: ''

        [[keys.command]]
        key = "ctrl+${direction.key}"
        type = "plugin_action"
        command = "vim-herdr-navigation.${direction.name}"
        description = "Navigate ${direction.name} (vim/herdr)"
      '')
      [
        {
          key = "h";
          name = "left";
        }
        {
          key = "j";
          name = "down";
        }
        {
          key = "k";
          name = "up";
        }
        {
          key = "l";
          name = "right";
        }
      ];
in
{
  _module.args.herdr = import ./lib.nix {
    inherit pkgs pkgs-unstable;
    shell = loginShell;
  };

  home.packages = [ pkgs-unstable.herdr ];

  # herdr cannot see an agent inside a doriath jail, so doriath names it on
  # the process herdr does see. Hosts without doriath skip this.
  programs = lib.optionalAttrs (options.programs ? doriath) {
    doriath.terminal.env.HERDR_AGENT = "{command}";
  };

  xdg.configFile = {
    "herdr/plugins.json".text = builtins.toJSON pluginRegistry;

    "herdr/config.toml".text = ''
      onboarding = false

      [terminal]
      default_shell = "${loginShell}"
      new_cwd = "follow"

      [update]
      version_check = false
      manifest_check = false

      [keys]
      prefix = "ctrl+a"
      navigate_workspace_up = "k"
      navigate_workspace_down = "j"
      focus_agent = "prefix+alt+1..9"
      clear_pane = "ctrl+shift+l"

      [ui]
      copy_on_select = true
      prompt_new_tab_name = false
      pane_borders = true
      pane_gaps = false

      [ui.sidebar.spaces]
      rows = [["state_icon", "workspace"]]

      [ui.sidebar.agents]
      rows = [["state_icon", "workspace", "tab"]]

      [ui.toast]
      delivery = "off"

      [ui.sound]
      enabled = false

      [advanced]
      scrollback_limit_bytes = 100000000

      # image.nvim draws through the kitty graphics protocol, which herdr only
      # passes through when this is on. Still experimental upstream.
      [experimental]
      kitty_graphics = true

      ${colorschemeConf}
      ${navigationKeys}

      [[keys.command]]
      key = "prefix+f"
      type = "plugin_action"
      command = "hotchpotch.herdr-tiny-fingers.open"
      description = "Copy hints (fingers mode)"
    '';
  };
}

{
  pkgs-unstable,
  vimHerdrNavigation,
  standard,
  config,
  lib,
  ...
}: let
  colorschemeConf =
    lib.optionalString (config.colorscheme == "standard")
    (builtins.readFile "${standard}/herdr/standard.dark.toml");

  navigationActions = [
    {
      id = "left";
      title = "Navigate left (Vim/herdr)";
      contexts = ["global"];
      command = ["bash" "navigate.sh" "left"];
    }
    {
      id = "down";
      title = "Navigate down (Vim/herdr)";
      contexts = ["global"];
      command = ["bash" "navigate.sh" "down"];
    }
    {
      id = "up";
      title = "Navigate up (Vim/herdr)";
      contexts = ["global"];
      command = ["bash" "navigate.sh" "up"];
    }
    {
      id = "right";
      title = "Navigate right (Vim/herdr)";
      contexts = ["global"];
      command = ["bash" "navigate.sh" "right"];
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
      platforms = ["linux" "macos"];
      actions = navigationActions;
      source.kind = "local";
    }
  ];

  navigationKeys =
    lib.concatMapStrings (direction: ''

      [[keys.command]]
      key = "ctrl+${direction.key}"
      type = "plugin_action"
      command = "vim-herdr-navigation.${direction.name}"
      description = "Navigate ${direction.name} (vim/herdr)"
    '') [
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
in {
  home.packages = [pkgs-unstable.herdr];

  xdg.configFile = {
    "herdr/plugins.json".text = builtins.toJSON pluginRegistry;

    "herdr/config.toml".text = ''
      onboarding = false

      [terminal]
      default_shell = "${config.shell.bin}"
      new_cwd = "follow"

      [update]
      version_check = false
      manifest_check = false

      [keys]
      prefix = "ctrl+a"
      navigate_workspace_up = "k"
      navigate_workspace_down = "j"
      focus_agent = "prefix+alt+1..9"

      [ui]
      copy_on_select = true
      prompt_new_tab_name = false
      sidebar_width = 20
      sidebar_min_width = 16
      sidebar_max_width = 28

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
    '';
  };
}

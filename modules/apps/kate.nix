{ standard, ... }:
{
  services.pacman.packages = [
    "kate"
    "markdownpart"
  ];

  xdg.dataFile."org.kde.syntax-highlighting/themes/Standard Dark.theme".source =
    "${standard}/kate/standard.dark.theme";

  programs.plasma.configFile."katerc" = {
    "KTextEditor Renderer" = {
      "Color Theme" = "Standard Dark";
      "Auto Color Theme Selection" = false;
    };

    "General" = {
      "Show Menu Bar" = false;
      "Show Status Bar" = false;
      "Show Url Nav Bar" = false;
    };

    "MainWindow"."MenuBar" = "Disabled";
  };

  programs.plasma.dataFile."kate/anonymous.katesession" = {
    "Kate Plugins".ktexteditorpreviewplugin = true;

    "MainWindow0" = builtins.listToAttrs (
      map
        (id: {
          name = "Kate-MDI-ToolView-${id}-Show-Button-In-Sidebar";
          value = false;
        })
        [
          "kate_private_plugin_katefiletreeplugin"
          "kateproject"
          "kateprojectgit"
          "lspclient_symbol_outline"
          "output"
          "diagnostics"
          "kate_plugin_katesearch"
          "kateprojectinfo"
          "kate_private_plugin_katekonsoleplugin"
        ]
    );
  };
}

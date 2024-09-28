{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs.unstable; [satty];
  xdg.configFile."satty/config.toml".text = ''
    [general]
    early-exit = true
    initial-tool = "arrow"
    output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S (edited).png"
    primary-highlighter = "block"
    save-after-copy = true

    [font]
    family = "${config.fontconfig.sans}"
    style = "Regular"

    [color-palette]
    first = "#88cc88"
    second = "#cc6666"
    third = "#66b2b2"
    fourth = "#ffcc66"
    fifth = "#333333"
    custom = "#ffffff"
  '';
}

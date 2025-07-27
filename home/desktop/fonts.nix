{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    adwaita-fonts
    nerd-fonts.sauce-code-pro
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
  ];
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        serif = [config.fontconfig.sans];
        sansSerif = [config.fontconfig.sans];
        monospace = [config.fontconfig.mono];
        emoji = [config.fontconfig.emoji];
      };
    };
  };
}

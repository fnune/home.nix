{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.darkman];
  home.file."${config.xdg.dataHome}/dark-mode.d/colorscheme-dark.sh" = {
    text = ''
      #!/bin/sh
      plasma-apply-colorscheme BreezeDark
    '';
    executable = true;
  };
  home.file."${config.xdg.dataHome}/light-mode.d/colorscheme-light.sh" = {
    text = ''
      #!/bin/sh
      plasma-apply-colorscheme BreezeLight
    '';
    executable = true;
  };
}

{
  pkgs,
  config,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      darkman = prev.darkman.overrideAttrs (_: {
        version = "0.0.0-dev";
        src = prev.fetchFromGitLab {
          owner = "WhyNotHugo";
          repo = "darkman";
          rev = "ee9c2394f3de4a66c7bbe048c9c07faaad8185b9";
          sha256 = "sha256-zQZWAj6QfXq6Nu5fyMEw4JqdTIQbiNkgzRvoC9xBHLM";
        };
      });
    })
  ];

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

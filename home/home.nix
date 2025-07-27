{...}: {
  home = {
    username = "fausto";
    homeDirectory = "/home/fausto";
    stateVersion = "23.05";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  news.display = "silent";
  systemd.user.startServices = "sd-switch";

  imports = [
    ../options.nix
    ./desktop/audio.nix
    ./desktop/authorization.nix
    ./desktop/fonts.nix
    ./desktop/plasma
    ./programs/bat.nix
    ./programs/browsers.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/flatpaks.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/jetbrains/jetbrains.nix
    ./programs/kitty/kitty.nix
    ./programs/llms/llms.nix
    ./programs/neovim/neovim.nix
    ./programs/ripgrep.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/utils.nix
    ./programs/vivid/vivid.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}

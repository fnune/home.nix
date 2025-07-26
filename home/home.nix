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
    ./desktop/applications.nix
    ./desktop/audio.nix
    ./desktop/photo.nix
    ./desktop/plasma
    ./notifier.nix
    ./programs/bat.nix
    ./programs/browsers.nix
    ./programs/direnv.nix
    ./programs/dropbox.nix
    ./programs/editorconfig.nix
    ./programs/fd.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/jetbrains/jetbrains.nix
    ./programs/kitty/kitty.nix
    ./programs/llms/llms.nix
    ./programs/neovim/neovim.nix
    ./programs/numi.nix
    ./programs/obs-studio.nix
    ./programs/psql/psql.nix
    ./programs/python.nix
    ./programs/ripgrep.nix
    ./programs/thunderbird.nix
    ./programs/tmux/tmux.nix
    ./programs/vivid/vivid.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}

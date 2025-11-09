{...}: {
  home = {
    username = "fausto";
    homeDirectory = "/home/fausto";
    stateVersion = "25.05";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  programs.home-manager.enable = true;
  programs.nh.enable = true;
  targets.genericLinux.enable = true;
  services.pacman.enable = true;
  news.display = "silent";
  systemd.user.startServices = "sd-switch";

  imports = [
    ../options.nix
    ./desktop/audio.nix
    ./desktop/fonts.nix
    ./desktop/plasma
    ./desktop/video.nix
    ./personal/personal.nix
    ./programs/applications.nix
    ./programs/bat.nix
    ./programs/browsers.nix
    ./programs/direnv.nix
    ./programs/editorconfig.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/jetbrains/jetbrains.nix
    ./programs/kitty/kitty.nix
    ./programs/lazygit.nix
    ./programs/llms/llms.nix
    ./programs/mise.nix
    ./programs/neovim/neovim.nix
    ./programs/networking.nix
    ./programs/pacman.nix
    ./programs/ripgrep.nix
    ./programs/ssh.nix
    ./programs/tmux/tmux.nix
    ./programs/utils.nix
    ./programs/vivid/vivid.nix
    ./programs/zsh.nix
    ./work/work.nix
  ];
}

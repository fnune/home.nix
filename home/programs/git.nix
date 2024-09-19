{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.unstable.difftastic];
  programs.gpg.enable = true;
  programs.git = {
    enable = true;
    userName = "Fausto Núñez Alberro";
    userEmail = "fausto.nunez@mailbox.org";
    includes = [
      {
        path = "${config.home.homeDirectory}/.local/gitconfig";
      }
    ];
    ignores = [
      ".ccls-cache"
      ".direnv"
      ".envrc"
      ".idea"
      ".nvim.lua"
      ".venv"
      ".vim"
      ".vim-bookmarks"
      ".vscode"
    ];
    extraConfig = {
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
      push.default = "current";
      pager.difftool = true;
      diff.tool = "difftastic";
      difftool = {
        prompt = false;
        difftastic.cmd = "${pkgs.unstable.difftastic}/bin/difft \"$LOCAL\" \"$REMOTE\"";
      };
    };
  };
}

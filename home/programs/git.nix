{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [difftastic diffstat];
  };
  programs.zsh = {
    shellAliases = {
      diffstat = "diffstat -C";
    };
  };
  programs.git = {
    enable = true;
    userName = config.profile.name;
    userEmail = config.profile.email.personal;
    includes = [
      {
        path = "${config.home.homeDirectory}/.local/gitconfig";
      }
    ];
    ignores = [
      ".ccls-cache"
      ".claude"
      ".direnv"
      ".envrc"
      ".idea"
      ".nvim.lua"
      ".venv"
      ".vim"
      ".vim-bookmarks"
      ".vscode"
      "CLAUDE.local.md"
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
        difftastic.cmd = "${pkgs.difftastic}/bin/difft \"$LOCAL\" \"$REMOTE\"";
      };
    };
  };
}

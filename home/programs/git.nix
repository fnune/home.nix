{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [diffstat];
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
      ".envrc.local"
      ".idea"
      ".nvim.lua"
      ".venv"
      ".vim"
      ".vim-bookmarks"
      ".vscode"
      "CLAUDE.local.md"
    ];
    aliases = {
      lg = "log --pretty=format:'%C(yellow)%h%C(reset) %C(green)%ad%C(reset) %s %C(blue)(%an)%C(reset)' --date=short";
    };
    extraConfig = {
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
      push.default = "current";
    };
  };
}

{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [diffstat gh];
  };
  programs.zsh = {
    shellAliases = {
      diffstat = "diffstat -C";
    };
  };
  programs.git = {
    enable = true;
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
    settings = {
      user = {
        name = config.profile.name;
        email = config.profile.email.personal;
        signingkey = "${config.profile.sshKeyPath}.pub";
      };
      alias = {
        lg = "log --pretty=format:'%C(yellow)%h%C(reset) %C(green)%ad%C(reset) %s %C(blue)(%an)%C(reset)' --date=short";
      };
      commit.gpgsign = true;
      gpg.format = "ssh";
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
      push.default = "current";
      diff.tool = config.jetbrains.tool;
      difftool.${config.jetbrains.tool}.cmd = "${config.jetbrains.tool} diff \"$LOCAL\" \"$REMOTE\"";
      merge.tool = config.jetbrains.tool;
      mergetool.${config.jetbrains.tool}.cmd = "${config.jetbrains.tool} merge \"$LOCAL\" \"$REMOTE\" \"$BASE\" \"$MERGED\"";
    };
  };
}

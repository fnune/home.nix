{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = [pkgs.difftastic];
    sessionVariables = {
      GIT_SSH_COMMAND = "ssh -i ${config.home.homeDirectory}/.ssh/id_ed25519 -o IdentitiesOnly=yes";
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
      ".aisession-instructions.md"
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
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
      };
    };
  };
}

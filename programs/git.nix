{config, ...}: {
  programs.git = {
    enable = true;
    userName = "Fausto Núñez Alberro";
    userEmail = "fausto.nunez@mailbox.org";
    delta.enable = true;
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
      ".mypy_cache"
      ".nvim.lua"
      ".venv"
      ".vim"
      ".vscode"
    ];
    extraConfig = {
      commit.gpgsign = true;
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
      push.default = "current";
    };
  };
}

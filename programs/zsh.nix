{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh = {enable = true;};
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.10.0";
          sha256 = "13ifm0667my9izsl2zwidf33vg6byjw5dnyrm27lcprn0g1rjkj0";
        };
      }
    ];
    shellAliases = {
      sudo = "sudo ";
    };
    history = {
      size = 100000;
      path = "${config.home.homeDirectory}/.zsh_history";
    };
    initExtra = ''
      for file in ~/.zsh/includes/*; do
        source "$file"
      done
    '';
    envExtra = ''
      PROMPT=$' %{\033[3m%}%(5~|…/%3~|%~)%{\033[0m%} %(?.%{$fg[green]%}.%{$fg[red]%}[%?] )=>%{$reset_color%} '

      export SHELL=$(which zsh)
      export KEYTIMEOUT=1

      # See https://unix.stackexchange.com/a/392710
      # This is usually ~/.local/bin
      USER_BINARIES_DIR=$(systemd-path user-binaries)

      # Add $USER_BINARIES_DIR to your $PATH if not already there
      if [[ $UID -ge 1000 && -d $USER_BINARIES_DIR && -z $(echo $PATH | grep -o $USER_BINARIES_DIR) ]]; then
        export PATH="$\{PATH}:$USER_BINARIES_DIR"
      fi
    '';
    profileExtra = ''
      function cdb() {
        inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
        if [ $inside_git_repo ]; then
          cd `git rev-parse --show-toplevel`
        else
          echo "Not a git project"
        fi
      }

      function untilfail() {
        while "$@"; do :; done
      }
    '';
  };

  home.packages = [pkgs.bfs];
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "bfs -type d -nohidden 2> /dev/null";
  };
}

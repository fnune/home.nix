{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [eza];
  programs = {
    zsh = {
      enable = config.shell.name == "zsh";
      autosuggestion.enable = true;
      oh-my-zsh.enable = true;
      plugins = with pkgs.unstable; [
        {
          name = "zsh-vi-mode";
          src = "${zsh-vi-mode}/share/zsh-vi-mode";
        }
        {
          name = "zsh-nix-shell";
          src = "${zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];
      shellAliases = {
        sudo = "sudo ";
        ls = "eza";
      };
      history = {
        size = 100000;
        path = "${config.home.homeDirectory}/.zsh_history";
      };
      initExtra = ''
        for file in ~/.zsh/includes/*(N); do
          source "$file"
        done
      '';
      envExtra = ''
        PROMPT=$' %{\033[3m%}%(5~|…/%3~|%~)%{\033[0m%} %(?.%{$fg[green]%}.%{$fg[red]%}[%?] )λ%{$reset_color%} '

        export SHELL=$(which zsh)
        export KEYTIMEOUT=1
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

        bindkey '^ ' autosuggest-accept
      '';
    };
  };
}

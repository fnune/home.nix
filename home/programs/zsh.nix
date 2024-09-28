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
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
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

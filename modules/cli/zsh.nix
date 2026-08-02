{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [ eza ];
  programs = {
    zsh = {
      enable = config.shell.name == "zsh";
      dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      plugins = with pkgs; [
        {
          name = "zsh-vi-mode";
          src = "${zsh-vi-mode}/share/zsh-vi-mode";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
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
      initContent =
        let
          windowTitle = "Terminal";
        in
        ''
          echo -ne "\e]0;${windowTitle}\a"

          function cdb() {
            inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
            if [ $inside_git_repo ]; then
              cd `git rev-parse --show-toplevel`
            else
              echo "Not a git project"
            fi
          }

          zvm_after_init_commands+=('bindkey "^ " autosuggest-accept')
        '';
      envExtra = ''
        PROMPT=' %F{normal}%~ %(?.%F{green}.%F{red})λ%f '

        export SHELL=$(which zsh)
        export KEYTIMEOUT=1
        export EZA_ICONS_AUTO=auto
        export PATH="$HOME/.local/bin:$PATH"
      '';
    };
  };
}

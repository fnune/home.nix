{
  config,
  pkgs,
  ...
}: let
  jetbrainsTool = config.jetbrains.tool;

  openInJetbrainsScript = pkgs.writeShellScript "open-in-jetbrains" ''
    PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    ${jetbrainsTool} "$PROJECT_DIR" "$@" >/dev/null 2>&1 &
    disown
  '';

  openInNvimScript = pkgs.writeShellScript "open-in-nvim" ''
    LINE=""
    FILENAME=""

    while [ $# -gt 0 ]; do
      case "$1" in
        --line)
          LINE="$2"
          shift 2
          ;;
        *)
          FILENAME="$1"
          shift
          ;;
      esac
    done

    if [ -n "$LINE" ]; then
      exec ''${EDITOR:-nvim} "+$LINE" "$FILENAME"
    else
      exec ''${EDITOR:-nvim} "$FILENAME"
    fi
  '';

  openInEditorScript = pkgs.writeShellScript "open-in-editor" ''
    PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

    if [ -d "$PROJECT_DIR/.idea" ]; then
      exec ${openInJetbrainsScript} "$@"
    else
      printf "No .idea folder found. Open in JetBrains IDE? (Y=JetBrains, n=\$EDITOR): " >&2
      read -r CHOICE
      if [ "$CHOICE" = "n" ] || [ "$CHOICE" = "N" ]; then
        exec ${openInNvimScript} "$@"
      else
        exec ${openInJetbrainsScript} "$@"
      fi
    fi
  '';
in {
  programs = {
    lazygit = {
      enable = true;
      settings = {
        promptToReturnFromSubprocess = false;
        os = {
          edit = "${openInEditorScript} {{filename}}";
          editAtLine = "${openInEditorScript} --line {{line}} {{filename}}";
          editAtLineAndWait = "${openInEditorScript} --line {{line}} {{filename}}";
          open = "${openInEditorScript} {{filename}}";
          openDirInEditor = "${openInEditorScript}";
        };
        git = {
          overrideGpg = true;
        };
      };
    };
    zsh.shellAliases.lg = "lazygit";
  };
}

{
  pkgs,
  pkgs-unstable,
  ...
}: let
  openInEditorScript = pkgs.writeShellScript "open-in-editor" ''
    set -euo pipefail
    CHOICES_FILE="''${XDG_STATE_HOME:-$HOME/.local/state}/lazygit-editor-choices"
    PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    JETBRAINS_EDITORS="goland rider"

    LINE=""
    FILENAME=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --line) LINE="$2"; shift 2 ;;
        *) FILENAME="$1"; shift ;;
      esac
    done

    exec_editor() {
      if [[ " $JETBRAINS_EDITORS " == *" $1 "* ]]; then
        "$1" "$PROJECT_DIR" "$FILENAME" &>/dev/null &
        disown
        exit 0
      fi
      if [[ -n "$LINE" ]]; then
        exec "$1" "+$LINE" "$FILENAME"
      else
        exec "$1" "$FILENAME"
      fi
    }

    EDITORS=("nvim")
    for tool in $JETBRAINS_EDITORS; do
      command -v "$tool" >/dev/null && EDITORS+=("$tool")
    done

    (( ''${#EDITORS[@]} == 1 )) && exec_editor "''${EDITORS[0]}"

    SAVED="$(grep "^$PROJECT_DIR=" "$CHOICES_FILE" 2>/dev/null | cut -d= -f2 || true)"
    for e in "''${EDITORS[@]}"; do
      [[ "$e" == "$SAVED" ]] && exec_editor "$SAVED"
    done

    echo "Select editor for this project:" >&2
    KEYS=""
    for e in "''${EDITORS[@]}"; do
      key="''${e:0:1}"
      if [[ "$e" == "nvim" ]]; then
        KEYS+="''${key^^}/"
        echo "  [''${key^^}] $e" >&2
      else
        KEYS+="$key/"
        echo "  [$key] $e" >&2
      fi
    done
    printf "Choice [%s]: " "''${KEYS%/}" >&2
    read -rn1 CHOICE
    echo >&2

    SELECTED="nvim"
    for e in "''${EDITORS[@]}"; do
      [[ "''${e:0:1}" == "$CHOICE" ]] && SELECTED="$e" && break
    done

    grep -v "^$PROJECT_DIR=" "$CHOICES_FILE" > "$CHOICES_FILE.tmp" 2>/dev/null || true
    echo "$PROJECT_DIR=$SELECTED" >> "$CHOICES_FILE.tmp"
    mv "$CHOICES_FILE.tmp" "$CHOICES_FILE"
    exec_editor "$SELECTED"
  '';
in {
  programs = {
    lazygit = {
      enable = true;
      package = pkgs-unstable.lazygit;
      settings = {
        promptToReturnFromSubprocess = false;
        os = {
          edit = "${openInEditorScript} {{filename}}";
          editAtLine = "${openInEditorScript} --line {{line}} {{filename}}";
          editAtLineAndWait = "${openInEditorScript} --line {{line}} {{filename}}";
          open = "xdg-open {{filename}}";
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

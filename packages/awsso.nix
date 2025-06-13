{pkgs, ...}:
pkgs.writeShellScriptBin "awsso" ''
  aws sso login 2>&1 | while IFS= read -r line; do
    echo "$line"

    if [[ "$line" == *"-"* ]]; then
      code=$(echo "$line" | grep -o "[A-Z0-9]\{4\}-[A-Z0-9]\{4\}")
      [ -n "$code" ] && echo -n "$code" | wl-copy && echo "Code $code copied to clipboard"
    fi
  done
  exit 0
''

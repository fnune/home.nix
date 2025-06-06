{pkgs, ...}:
pkgs.writeShellScriptBin "awsso" ''
  mkfifo /tmp/awsso_pipe
  trap "rm -f /tmp/awsso_pipe" EXIT

  aws sso login 2>&1 > /tmp/awsso_pipe &
  aws_pid=$!

  while IFS= read -r line; do
  echo "$line"

  if [[ "$line" == *"https://"* ]]; then
  url=$(echo "$line" | grep -o "https://[^[:space:]]*")
  [ -n "$url" ] && xdg-open "$url"
  fi

  if [[ "$line" == *"-"* ]]; then
  code=$(echo "$line" | grep -o "[A-Z0-9]\{4\}-[A-Z0-9]\{4\}")
  [ -n "$code" ] && echo -n "$code" | wl-copy && echo "Code $code copied to clipboard"
  fi
  done < /tmp/awsso_pipe

  wait $aws_pid
''

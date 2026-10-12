{ pkgs, ... }:
let
  earendilBrowser = pkgs.writeShellApplication {
    name = "earendil-browser";
    runtimeInputs = [ pkgs.tigervnc ];
    text = ''
      host=earendil
      local_port=5901
      display_socket=/run/user/1000/chrome-display.sock

      ssh -N -o ExitOnForwardFailure=yes -L "$local_port:$display_socket" "$host" &
      tunnel=$!
      trap 'kill "$tunnel" 2>/dev/null' EXIT

      tunnel_is_listening() { (exec 3<>"/dev/tcp/localhost/$local_port") 2>/dev/null; }

      until tunnel_is_listening; do
        kill -0 "$tunnel" 2>/dev/null || exit 1
        sleep 0.2
      done

      vncviewer "localhost:$local_port"
    '';
  };
in
{
  home.packages = [ earendilBrowser ];
}

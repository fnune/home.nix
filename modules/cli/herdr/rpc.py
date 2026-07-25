import json
import os
import socket
import sys

path = os.environ.get("HERDR_SOCKET_PATH") or os.path.expanduser(
    "~/.config/herdr/herdr.sock"
)

connection = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
connection.connect(path)
connection.sendall((json.dumps(json.load(sys.stdin)) + "\n").encode())

buffer = b""
while not buffer.endswith(b"\n"):
    chunk = connection.recv(65536)
    if not chunk:
        break
    buffer += chunk

response = json.loads(buffer)
if "error" in response:
    print(json.dumps(response["error"]), file=sys.stderr)
    sys.exit(1)

print(json.dumps(response.get("result", {})))

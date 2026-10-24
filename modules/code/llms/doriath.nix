{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  doriath = lib.getExe config.programs.doriath.package;
  claude = "${pkgs-unstable.claude-code}/bin/claude";
in
{
  programs.doriath = {
    enable = true;
    approvals.web.enable = true;
    modules.nix-home.mounts = [
      {
        path = "~/.nix-profile";
        missing = "skip";
      }
      {
        path = "~/.local/state/nix";
        missing = "skip";
      }
      {
        path = "~/.local/state/home-manager";
        missing = "skip";
      }
    ];
    profiles.default = {
      description = "Any project without a profile of its own";
      modules = [
        "nix-home"
        "vcs-readonly"
        "docs"
        "clipboard"
        "claude"
      ];
      secrets.signing.file = "~/.config/doriath/keys/agent-signing";
      signing.key = "signing";
    };
    profiles.home-nix = {
      description = "This home-manager configuration";
      modules = [
        "nix-home"
        "vcs-readwrite"
        "docs"
        "nix-daemon"
        "pre-commit"
        "clipboard"
        "claude"
      ];
      mounts = [
        {
          path = "~/.worktrees/.home.nix";
          mode = "write";
          missing = "skip";
        }
      ];
      secrets.signing.file = "~/.config/doriath/keys/agent-signing";
      signing.key = "signing";
    };
  };

  # Inside a session DORIATH_BROKER is set, so the jail runs Claude itself
  # instead of starting a jail in the jail.
  home.packages = [
    (lib.hiPrio (
      pkgs.writeShellScriptBin "claude" ''
        if [ -n "''${DORIATH_BROKER:-}" ]; then exec ${claude} "$@"; fi
        exec ${doriath} run --profile default -- ${claude} "$@"
      ''
    ))
  ];
}

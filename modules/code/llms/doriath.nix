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
    profiles.default = {
      description = "Any project without a profile of its own";
      modules = [
        "base"
        "vcs"
        "docs"
        "claude"
      ];
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

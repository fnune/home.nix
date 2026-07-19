{
  pkgs,
  pkgs-unstable,
  shell,
}: let
  rpc = pkgs.writeShellScriptBin "herdr-rpc" ''
    exec ${pkgs.python3}/bin/python3 ${./rpc.py}
  '';

  applyWorkspace = pkgs.writeShellApplication {
    name = "herdr-apply-workspace";
    runtimeInputs = [pkgs-unstable.herdr pkgs.jq rpc];
    text = builtins.readFile ./apply-workspace.sh;
  };
  outliveCommand = command: [
    shell
    "-c"
    "${pkgs.lib.escapeShellArgs command}; exec ${shell}"
  ];
in {
  pane = {
    cwd ? null,
    command ? null,
    label ? null,
  }:
    {type = "pane";}
    // pkgs.lib.optionalAttrs (cwd != null) {inherit cwd;}
    // pkgs.lib.optionalAttrs (command != null) {command = outliveCommand command;}
    // pkgs.lib.optionalAttrs (label != null) {inherit label;};

  split = {
    direction,
    first,
    second,
    ratio ? 0.5,
  }: {
    type = "split";
    inherit direction ratio first second;
  };

  mkProvisioner = {
    name,
    workspaces,
    focus ? null,
  }: let
    toWorkspace = workspace:
      {inherit (workspace) label tabs;}
      // pkgs.lib.optionalAttrs (workspace.focusTab or null != null) {
        focus_tab = workspace.focusTab;
      };

    spec =
      {workspaces = map toWorkspace workspaces;}
      // pkgs.lib.optionalAttrs (focus != null) {inherit focus;};

    specFile = pkgs.writeText "herdr-workspace-${name}.json" (builtins.toJSON spec);
  in
    pkgs.writeShellScriptBin name ''
      exec ${applyWorkspace}/bin/herdr-apply-workspace ${specFile} "$@"
    '';
}

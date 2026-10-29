{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  nixvimPackage,
  ...
}:
let
  doriath = lib.getExe config.programs.doriath.package;
  claude = "${pkgs-unstable.claude-code}/bin/claude";

  # Claude's official LSP plugins run fixed command names and install nothing,
  # so this hands them the servers nixvim already uses.
  nixvimServers = nixvimPackage.config.lsp.servers;
  languageServers = pkgs.symlinkJoin {
    name = "claude-language-servers";
    paths = [
      nixvimServers.gopls.package
      nixvimServers.jdtls.package
      nixvimServers.lua_ls.package
      nixvimServers.rust_analyzer.package
      (pkgs.writeShellScriptBin "pyright-langserver" ''
        exec ${nixvimServers.basedpyright.package}/bin/basedpyright-langserver "$@"
      '')
      (pkgs.writeShellScriptBin "typescript-language-server" ''
        exec ${lib.getExe nixvimServers.vtsls.package} "$@"
      '')
    ];
  };
in
{
  programs.doriath = {
    enable = true;
    modules.jdtls = {
      description = "The Java language server's index of each project, in a cache.";
      caches = [ { path = "~/.cache/jdtls"; } ];
    };
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
        "jdtls"
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
        "github"
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
      secrets.github.command = [
        (lib.getExe pkgs.gh)
        "auth"
        "token"
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
        # Appended so that a project's dev shell keeps its own server versions.
        export PATH="$PATH:${languageServers}/bin"
        if [ -n "''${DORIATH_BROKER:-}" ]; then exec ${claude} "$@"; fi
        exec ${doriath} run --profile default -- ${claude} "$@"
      ''
    ))
  ];
}

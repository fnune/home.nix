{
  pkgs-unstable,
  config,
  ...
}: {
  home = let
    homeDir = config.home.homeDirectory;
  in {
    packages = with pkgs-unstable; [claude-code codex gemini-cli-bin];

    file = {
      "${homeDir}/.claude/CLAUDE.md".source = ./AGENTS.md;
      "${homeDir}/.claude/settings.json".source = ./settings.json;
      "${homeDir}/.codex/AGENTS.md".source = ./AGENTS.md;
    };
  };
}

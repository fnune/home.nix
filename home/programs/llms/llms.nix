{
  pkgs-unstable,
  config,
  ...
}: {
  home = {
    packages = with pkgs-unstable; [claude-code gemini-cli-bin];

    file = {
      "${config.home.homeDirectory}/.claude/CLAUDE.md".source = ./CLAUDE.md;
      "${config.home.homeDirectory}/.claude/settings.json".source = ./settings.json;
    };

    sessionVariables = {
      ANTHROPIC_MODEL = "claude-opus-4-5-20251101"; # 4.6 is too expensive
    };
  };
}

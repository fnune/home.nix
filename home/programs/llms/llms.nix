{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs.unstable; [claude-code gemini-cli];

    file = {
      "${config.home.homeDirectory}/.claude/CLAUDE.md".source = ./CLAUDE.md;
    };
  };
}

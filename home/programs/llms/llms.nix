{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [claude-code];

    file = {
      "${config.home.homeDirectory}/.claude/CLAUDE.md".source = ./CLAUDE.md;
    };
  };
}

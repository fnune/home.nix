{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs.unstable; [claude-code];

    file = {
      "${config.home.homeDirectory}/.claude/CLAUDE.md".source = ./CLAUDE.md;
    };
  };
}

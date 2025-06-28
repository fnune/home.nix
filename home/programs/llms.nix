{pkgs, ...}: {
  home.packages = with pkgs.unstable; [claude-code] ++ (with pkgs.development; [gemini-cli angular-language-server]);
}

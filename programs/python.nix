{pkgs, ...}: {
  home.packages = with pkgs; [
    python311
    python311Packages.pip
    black
    ruff
  ];
}

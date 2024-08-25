{pkgs, ...}: {
  home.packages = with pkgs; [
    (python3.withPackages (ps: [ps.pip]))
  ];
}

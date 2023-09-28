{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_20
    nodePackages.prettier
    nodePackages.prettier_d_slim
    nodePackages.eslint
    nodePackages.eslint_d
  ];
}

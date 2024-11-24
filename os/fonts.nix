{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    inter
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
  ];
}

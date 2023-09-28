{pkgs, ...}: {
  home.packages = with pkgs; [pspg];
  home.file.".pspgconf".source = ./pspgconf;
  home.file.".psqlrc".source = ./psqlrc;
}

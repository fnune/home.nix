{pkgs, ...}: {
  home = {
    packages = with pkgs; [pspg];
    file = {
      ".pspgconf".source = ./pspgconf;
      ".psqlrc".source = ./psqlrc;
    };
  };
}

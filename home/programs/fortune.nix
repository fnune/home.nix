{pkgs, ...}: let
  meditations-fortune-src = pkgs.fetchFromGitHub {
    owner = "fnune";
    repo = "meditations-fortune";
    rev = "14dccff8b95aae7ba2ffdbebc7fc62f4c1fbf40b";
    sha256 = "sha256-rIT45Y4A5dfO7L5BjludrZqFy120SpitGXRa1ek76jA";
  };
  meditations-fortune = import meditations-fortune-src {inherit pkgs;};
in {
  home.packages = [pkgs.fortune meditations-fortune];
}

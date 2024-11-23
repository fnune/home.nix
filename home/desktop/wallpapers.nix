{
  pkgs,
  config,
  ...
}: let
  source = pkgs.fetchFromGitHub {
    owner = "dharmx";
    repo = "walls";
    rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14";
    sha256 = "sha256-M96jJy3L0a+VkJ+DcbtrRAquwDWaIG9hAUxenr/TcQU";
  };
in {
  home.file.${config.wallpapers}.source = source + "/mountain";
}

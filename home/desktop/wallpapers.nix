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
  excludes = [
    "a_body_of_water_with_rocks_and_a_cliff.jpg"
    "a_close_up_of_rocks.jpg"
    "a_iceberg_in_the_water_with_mountains_in_the_background.jpg"
    "a_mountain_range_with_snow_on_top.jpeg"
    "a_mountain_range_with_snow_on_top_01.jpg"
    "a_mountain_with_a_road_going_through_it.jpg"
    "a_mountain_with_clouds_above_it.png"
    "a_mountain_with_snow_and_clouds_01.jpg"
    "a_mountain_with_snow_on_top_01.jpg"
    "a_person_on_a_cliff.jpg"
    "a_river_in_a_snowy_landscape.jpg"
    "a_rocky_island_with_waves_crashing_on_it.jpg"
    "a_rocky_island_with_waves_crashing_on_it.png"
    "a_silhouette_of_trees_on_a_hill.jpg"
    "a_small_waterfall_in_a_grassy_area.jpg"
    "a_snowy_mountain_tops_with_blue_sky.jpg"
    "a_snowy_mountain_tops_with_clouds_in_the_background.png"
    "a_tree_in_a_body_of_water_with_mountains_in_the_background.jpg"
    "a_waterfall_in_the_snow.jpg"
  ];
  wallpapers = pkgs.runCommand "filter-wallpapers" {} ''
    cp -r ${source}/mountain $out
    cd $out
    chmod -R +w .
    rm ${builtins.concatStringsSep " " excludes}
  '';
in {
  home = {
    packages = with pkgs.unstable; [plasma-plugin-blurredwallpaper];
    file.${config.wallpapers}.source = wallpapers;
  };
}

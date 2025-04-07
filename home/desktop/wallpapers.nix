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
    "a_aerial_view_of_a_snowy_mountain_range_01.jpg"
    "a_blue_and_white_water.jpg"
    "a_body_of_water_with_rocks_and_a_cliff.jpg"
    "a_building_in_the_woods.jpg"
    "a_close_up_of_rocks.jpg"
    "a_cup_of_coffee_with_foam.jpg"
    "a_deer_with_antlers_grazing_on_grass.jpg"
    "a_group_of_fish_swimming_in_a_pond.jpg"
    "a_iceberg_in_the_water_with_mountains_in_the_background.jpg"
    "a_mountain_range_with_snow_on_top.jpeg"
    "a_mountain_range_with_snow_on_top_01.jpg"
    "a_mountain_with_a_road_going_through_it.jpg"
    "a_mountain_with_clouds_above_it.png"
    "a_mountain_with_snow_and_clouds_01.jpg"
    "a_mountain_with_snow_on_top_01.jpg"
    "a_person_on_a_cliff.jpg"
    "a_pile_of_rocks.jpg"
    "a_river_in_a_snowy_landscape.jpg"
    "a_rocky_island_with_waves_crashing_on_it.jpg"
    "a_rocky_island_with_waves_crashing_on_it.png"
    "a_silhouette_of_trees_on_a_hill.jpg"
    "a_small_waterfall_in_a_grassy_area.jpg"
    "a_snowy_mountain_tops_with_blue_sky.jpg"
    "a_snowy_mountain_tops_with_clouds_in_the_background.png"
    "a_tree_in_a_body_of_water_with_mountains_in_the_background.jpg"
    "a_tree_with_pink_flowers.png"
    "a_waterfall_in_the_snow.jpg"
    "waves_crashing_on_rocks.png"
  ];
  wallpapers = pkgs.runCommand "filter-wallpapers" {} ''
    mkdir -p $out
    chmod -R +w $out

    cp --no-clobber ${source}/{aerial,mountain,nature}/*.{jpg,jpeg,png} $out/

    pushd $out
      rm ${builtins.concatStringsSep " " excludes}
    popd
  '';
in {
  home = {
    file.${config.wallpapers}.source = wallpapers;
  };
}

{
  pkgs,
  config,
  ...
}: let
  voltaHome = "${config.home.homeDirectory}/.volta";
in {
  home.packages = with pkgs; [volta];
  home.sessionVariables.VOLTA_HOME = voltaHome;
  home.sessionPath = ["${voltaHome}/bin"];
}

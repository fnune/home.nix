{pkgs, ...}: let
  nvdProfileDiffScript = builtins.readFile ./nvd-profile-diff.sh;
  nvdSystemDiffScript = builtins.readFile ./nvd-system-diff.sh;
  nixSystemUpdateScript = builtins.readFile ./nix-system-update.sh;

  nvdProfileDiff = pkgs.writeShellScriptBin "nvd-profile-diff" nvdProfileDiffScript;
  nvdSystemDiff = pkgs.writeShellScriptBin "nvd-system-diff" nvdSystemDiffScript;
  nixSystemUpdate = pkgs.writeShellScriptBin "nix-system-update" nixSystemUpdateScript;
in {
  home.packages = [pkgs.nvd nvdProfileDiff nvdSystemDiff nixSystemUpdate];
}

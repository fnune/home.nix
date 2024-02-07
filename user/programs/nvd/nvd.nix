{pkgs, ...}: let
  nvdProfileDiffScript = builtins.readFile ./nvd-profile-diff.sh;
  nvdSystemDiffScript = builtins.readFile ./nvd-system-diff.sh;

  nvdProfileDiff = pkgs.writeShellScriptBin "nvd-profile-diff" nvdProfileDiffScript;
  nvdSystemDiff = pkgs.writeShellScriptBin "nvd-system-diff" nvdSystemDiffScript;
in {
  home.packages = [pkgs.nvd nvdProfileDiff nvdSystemDiff];
}

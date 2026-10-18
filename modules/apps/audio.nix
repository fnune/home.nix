{ pkgs-unstable, ... }:
{
  home.packages = [
    (pkgs-unstable.reaper.override { jackLibrary = pkgs-unstable.pipewire.jack; })
  ];
}

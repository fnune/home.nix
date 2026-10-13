{ ... }: {
  imports = [
    ./headless.nix
    ./godot.nix
    ./lexaloffle.nix
    ./llms/doriath.nix
  ];
}

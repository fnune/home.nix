{ ... }: {
  imports = [
    ./editorconfig.nix
    ./git.nix
    ./godot.nix
    ./jujutsu.nix
    ./lexaloffle.nix
    ./mise.nix
    ./npm.nix
    ./podman.nix
    ./llms/llms.nix
    ./nixvim/home.nix
  ];
}

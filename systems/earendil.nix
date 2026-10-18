_: {
  imports = [ ./base.nix ];

  nix.settings.trusted-users = [ "fausto" ]; # For nix copy of unsigned closures, see docs/earendil.md.
}

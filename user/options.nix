{lib, ...}: {
  options = {
    machine.scale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "The display scaling that this machine uses on its primary monitor";
    };
  };
}

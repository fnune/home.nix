_: {
  users.users.fausto.extraGroups = ["jackaudio" "audio"];
  security.rtkit.enable = true;
  services = {
    pulseaudio = {
      enable = false;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}

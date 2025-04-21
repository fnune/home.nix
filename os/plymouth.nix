{pkgs, ...}: {
  boot = {
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      theme = "spinner";
      font = "${pkgs.adwaita-fonts}/share/fonts/Adwaita/AdwaitaSans-Regular.ttf";
    };
    kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"];
  };
}

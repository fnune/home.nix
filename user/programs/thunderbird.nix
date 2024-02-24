{pkgs, ...}: {
  home.packages = [pkgs.protonmail-bridge];

  programs = {
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird-bin;
      profiles = {};
      settings = {
        # Search Settings -> Config Editor to grab these.
        "mail.folder.views.version" = 1;
        "mail.uidensity" = 2;
        "mailnews.default_sort_order" = 2;
        "mailnews.default_sort_type" = 18;
        "mailnews.message_display.disable_remote_image" = false;
        "mailnews.start_page.enabled" = false;
      };
    };
  };

  systemd.user.services = {
    "protonmail-bridge" = {
      Unit = {
        Description = "ProtonMail Bridge";
        PartOf = ["graphical-session.target"];
        After = ["network.target"];
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
        Restart = "always";
        Environment = "PATH=${pkgs.gnome3.gnome-keyring}/bin";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}

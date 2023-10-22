{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    kdenlive
    onlyoffice-bin
    screenkey
    signal-desktop
    slack
    spotify
    vlc
  ];

  programs = {
    thunderbird = {
      enable = true;
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
}

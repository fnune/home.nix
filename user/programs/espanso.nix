{pkgs, ...}: {
  # Suggested packages:
  # espanso install actually-all-emojis
  # espanso install lorem
  # espanso install tableflip-package
  # espanso install typofixer-en
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
    configs = {
      default = {
        show_notifications = false;
      };
    };
    matches = {
      base = {
        matches = [
          {
            trigger = ",n";
            replace = "–";
          }
          {
            trigger = ",m";
            replace = "—";
          }
          {
            trigger = ":shrug:";
            replace = "¯\\_(ツ)_/¯";
          }
        ];
      };
    };
  };
}

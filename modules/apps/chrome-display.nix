{ pkgs, ... }:
let
  display = ":1";
  width = 1920;
  height = 1080;
in
{
  services.pacman.packages = [ "tigervnc" ];

  systemd.user.services = {
    chrome-display = {
      Unit.Description = "Virtual display for Chrome";
      Service = {
        ExecStart = "/usr/bin/Xvnc ${display} -geometry ${toString width}x${toString height} -depth 24 -nolisten tcp -nolisten local -rfbport -1 -rfbunixpath %t/chrome-display.sock -SecurityTypes None -AlwaysShared";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };

    chrome = {
      Unit = {
        Description = "Google Chrome on the virtual display";
        Requires = [ "chrome-display.service" ];
        After = [ "chrome-display.service" ];
      };
      Service = {
        Environment = [ "DISPLAY=${display}" ];
        ExecStart = "${pkgs.google-chrome}/bin/google-chrome-stable --no-first-run --password-store=basic --window-position=0,0 --window-size=${toString width},${toString height}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}

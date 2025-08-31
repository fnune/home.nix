{config, ...}: let
  matchClass = class: {
    window-class = {
      value = class;
      type = "substring";
    };
  };
  matchClassAndTitle = class: title: {
    window-class = {
      value = class;
      type = "substring";
    };
    title = {
      value = title;
      type = "substring";
    };
  };
  sendToDesktop = desktop: {
    desktops = {
      value = "Desktop_${toString desktop}";
      apply = "initially";
    };
  };
  maximize = {
    maximizehoriz = {
      value = true;
      apply = "initially";
    };
    maximizevert = {
      value = true;
      apply = "initially";
    };
  };
in {
  programs.plasma.window-rules = [
    {
      description = "Start terminals maximized";
      match = matchClass config.terminal.name;
      apply = maximize;
    }
    {
      description = "Send Chromium to desktop";
      match = matchClassAndTitle "chromium" "Chromium";
      apply = sendToDesktop 1;
    }
    {
      description = "Send Chromium DevTools to desktop";
      match = matchClassAndTitle "chromium" "DevTools";
      apply = sendToDesktop 3;
    }
    {
      description = "Send Firefox to desktop";
      match = matchClass "firefox";
      apply = sendToDesktop 4;
    }
    {
      description = "Send Thunderbird to desktop";
      match = matchClass "thunderbird";
      apply = sendToDesktop 6;
    }
    {
      description = "Send Signal to desktop";
      match = matchClass "signal";
      apply = sendToDesktop 6;
    }
    {
      description = "Send Slack to desktop";
      match = matchClass "com.slack.Slack";
      apply = sendToDesktop 7;
    }
    {
      description = "Send Obsidian to desktop";
      match = matchClass "obsidian";
      apply = sendToDesktop 10;
    }
  ];
}

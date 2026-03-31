_: {
  programs.npm = {
    enable = true;
    settings = {
      ignore-scripts = true;
      fund = false;
      audit = false;
      update-notifier = false;
    };
  };
}

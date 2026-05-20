{config, ...}: {
  home.file = {
    ".npmrc".text = ''
      ignore-scripts=true
      fund=false
      audit=false
      update-notifier=false
    '';

    "${config.xdg.configHome}/pnpm/rc".text = ''
      ignore-scripts=true
      side-effects-cache=false
    '';

    ".yarnrc.yml".text = ''
      enableScripts: false
    '';

    "${config.xdg.configHome}/pip/pip.conf".text = ''
      [install]
      require-virtualenv = true
    '';
  };
}

{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    ardour
    calf
    carla
    distrho
    drumgizmo
    guitarix
    gxplugins-lv2
    lsp-plugins
    neural-amp-modeler-lv2
    qpwgraph
    reaper
    rkrlv2
    swh_lv2
    x42-avldrums
    x42-gmsynth
    x42-plugins
    yabridge
    yabridgectl
  ];

  systemd.user.sessionVariables = {
    DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LXVST_PATH = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
    VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
  };
}

{
  config,
  pkgs,
  ...
}: {
  # This is currently not working due to this bug https://bugs.kde.org/show_bug.cgi?id=502957
  home.activation = {
    addColorChooserPalette = pkgs.lib.mkAfter ''
      CONFIG_FILE="${config.home.homeDirectory}/.config/QtProject.conf"
      CRUDINI="${pkgs.crudini}/bin/crudini"

      touch "$CONFIG_FILE"

      # Palette from https://design-system.service.gov.uk/styles/colour
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\0" 4278218556  # Green (#00703c)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\1" 4283181969  # Red (#d4351c)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\2" 4292031771  # Orange (#f47738)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\3" 4289770421  # Black (#0b0c0c)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\4" 4294211128  # White (#ffffff)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\5" 4285428142  # Blue (#1d70b8)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\6" 4278848267  # Dark Blue (#003078)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\7" 4287638151  # Light Blue (#5694ca)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\8" 4294967295  # Purple (#4c2c92)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\9" 4292098175  # Mid Grey (#b1b4b6)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\10" 4280053687 # Light Purple (#6f72af)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\11" 4294219965 # Bright Purple (#912b88)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\12" 4278202487 # Pink (#d53880)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\13" 4280787094 # Light Pink (#f499be)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\14" 4283798473 # Turquoise (#28a197)
      "$CRUDINI" --set "$CONFIG_FILE" Qt "customColors\\15" 8748107    # Light Green (#85994b)
    '';
  };
}

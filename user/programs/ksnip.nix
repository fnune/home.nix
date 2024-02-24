{
  config,
  lib,
  pkgs,
  ...
}: let
  ksnipDefaultToolWidth = "7";
  ksnipConfig = pkgs.writeText "ksnip.conf" ''
    [Application]
    AutoHideDocks=false
    PromptSaveBeforeExit=false
    SaveDirectory=${config.home.homeDirectory}/Pictures
    SavePosition=false
    UseSingleInstanceString=false
    UseTabs=false
    UseTrayIcon=false

    [Painter]
    SaveToolsSelection=true

    [KImageAnnotator]
    ToolType=6

    ToolColor_0=@Variant(\0\0\0\x43\x1\xff\xff\0\0\0\0\0\0\0\0)
    ToolFillType_0=2
    ToolFont_0=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@&\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    ToolObfuscateFactor_0=1
    ToolOpacity_0=1
    ToolShadowEnabled_0=false
    ToolTextColor_0=@Variant(\0\0\0\x43\x1\xff\xffWW\xe3\xe3\x89\x89\0\0)
    ToolWidth_0=1

    ToolColor_5=@Variant(\0\0\0\x43\x1\xff\xffWW\xe3\xe3\x89\x89\0\0)
    ToolWidth_5=${ksnipDefaultToolWidth}

    ToolColor_6=@Variant(\0\0\0\x43\x1\xff\xffWW\xe3\xe3\x89\x89\0\0)
    ToolShadowEnabled_6=false
    ToolWidth_6=${ksnipDefaultToolWidth}

    ToolFont_7=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@.\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0K\x10)

    ToolColor_8=@Variant(\0\0\0\x43\x1\xff\xffWW\xe3\xe3\x89\x89\0\0)
    ToolFillType_8=0
    ToolFont_8=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@.\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0K\x10)
    ToolShadowEnabled_8=false
    ToolWidth_8=${ksnipDefaultToolWidth}

    ToolColor_10=@Variant(\0\0\0\x43\x1\xff\xff&&\xa2\xa2ii\0\0)
    ToolTextColor_10=@Variant(\0\0\0\x43\x1\xff\xff\xff\xff\xff\xff\xff\xff\0\0)

    ToolFillType_13=2
    ToolFont_13=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@@\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
    ToolShadowEnabled_13=false
    ToolTextColor_13=@Variant(\0\0\0\x43\x1\xff\xffWW\xe3\xe3\x89\x89\0\0)
    ToolWidth_13=2
  '';
in {
  home.packages = [pkgs.unstable.ksnip];
  home.activation.createKsnipConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ksnipConfigPath=${config.home.homeDirectory}/.config/ksnip/ksnip.conf
    if [ ! -f $ksnipConfigPath ]; then
      mkdir -p ${config.home.homeDirectory}/.config/ksnip
      cp ${ksnipConfig} $ksnipConfigPath
      chmod 644 $ksnipConfigPath
    fi
  '';
}

_: {
  imports = [ ./desktop.nix ];

  environment.etc."sdboot-manage.conf.d/99-tuxedo.conf".text = ''
    LINUX_OPTIONS="zswap.enabled=0 quiet splash amdgpu.dcdebugmask=0x10 acpi.ec_no_wakeup=1 amdgpu.ppfeaturemask=0xfff73fff"
  '';
}

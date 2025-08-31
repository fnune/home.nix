{pkgs, ...}: {
  xdg = {
    configFile = {
      "environment.d/ssh_askpass.conf".text = ''
        SSH_ASKPASS=/usr/bin/ksshaskpass
        SSH_ASKPASS_REQUIRE=prefer
      '';

      "kwalletrc".text = ''
        [Wallet]
        Enabled=true
        Default Wallet=kdewallet
        First Use=false
      '';

      "autostart/ssh-add-keys.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Load SSH Keys
        Exec=${pkgs.writeShellScript "ssh-add-keys" ''
          kwallet_loaded() {
            qdbus6 org.kde.kwalletd6 /modules/kwalletd6 org.kde.KWallet.isOpen kdewallet 2>/dev/null
          }

          until kwallet_loaded; do sleep 1; done
          ssh-add ~/.ssh/id_ed25519 2>/dev/null
        ''}
        Hidden=false
        NoDisplay=true
        X-KDE-autostart-after=panel
        X-KDE-StartupNotify=false
      '';
    };
  };
}

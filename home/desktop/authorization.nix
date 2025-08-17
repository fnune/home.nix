{pkgs, ...}: {
  systemd.user.services.ssh-add-keys = {
    Unit = {
      Description = "Add SSH keys to agent after KWallet is available";
      After = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "ssh-add-keys" ''
        while ! ${pkgs.kdePackages.qttools}/bin/qdbus org.kde.kwalletd6 /modules/kwalletd6 org.kde.KWallet.isOpen kdewallet >/dev/null 2>&1; do
          sleep 1
        done

        for KEY in $(ls $HOME/.ssh/id_ed25519* 2>/dev/null | grep -v \.pub); do
          ${pkgs.openssh}/bin/ssh-add -q ''${KEY} </dev/null
        done
      '';
    };
    Install.WantedBy = ["default.target"];
  };
}

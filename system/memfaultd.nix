{
  pkgs,
  lib,
  config,
  memfaultd,
  ...
}: let
  memfaultd-config = pkgs.writeText "memfaultd.conf" ''
    {
      "persist_dir": "/var/lib/memfault",
      "tmp_dir": "/var/tmp",
      "tmp_dir_min_headroom_kib": 10240,
      "tmp_dir_min_inodes": 100,
      "tmp_dir_max_usage_kib": 102400,
      "upload_interval_seconds": 60,
      "heartbeat_interval_seconds": 30,
      "enable_data_collection": true,
      "enable_dev_mode": true,
      "software_version": "0.0.0-faustos-nixos",
      "software_type": "faustos-nixos",
      "project_key": "JGqpQcMsO5vLQHrASzbRmqOB1Udon0D0",
      "reboot": { "last_reboot_reason_file": "/var/lib/memfault/last_reboot_reason" },
      "logs": {
        "log_to_metrics": {
          "rules": [
            {
              "type": "count_matching",
              "filter": {},
              "pattern": "Out of memory: Killed process \\d+ \\((.*)\\)",
              "metric_name": "oomkill_$1"
            }
          ]
        }
      }
    }
  '';
  memfault-device-info = pkgs.writeScriptBin "memfault-device-info" ''
    #!/bin/sh
    echo MEMFAULT_DEVICE_ID="${config.networking.hostName}"
    echo MEMFAULT_HARDWARE_VERSION="${config.networking.hostName}-hardware"
  '';
in {
  environment.systemPackages = [memfaultd memfault-device-info pkgs.fluent-bit];
  environment.etc."memfaultd.conf".source = memfaultd-config;

  systemd.services.memfaultd = {
    description = "memfaultd daemon";
    after = ["local-fs.target" "network.target" "dbus.service"];
    before = ["collectd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "forking";
      PIDFile = "/run/memfaultd.pid";
      ExecStart = "${memfaultd}/bin/memfaultd --daemonize";
      ExecStartPost = "-/bin/sh -c 'while [ ! -s /run/memfaultd.pid ]; do sleep 0.1; done'";
      Restart = "on-failure";
      User = "root";
      Group = "root";
      Environment = "PATH=" + lib.makeBinPath [memfault-device-info];
    };
  };

  services.collectd = {
    enable = true;
    include = ["${./collectd.conf}"];
  };

  systemd.services.fluent-bit = {
    description = "fluent-bit daemon";
    after = ["local-fs.target" "network.target" "dbus.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.fluent-bit}/bin/fluent-bit --config=${./fluent-bit.conf}";
      Restart = "on-failure";
      User = "root";
      Group = "root";
    };
  };
}

{pkgs}:
pkgs.buildFHSEnv {
  name = "memfault-fhs-shell";
  profile = ''
    export MAMBA_ROOT_PREFIX=~/.micromamba
    eval "$(micromamba shell hook --shell zsh)"

    if ! micromamba activate memfault; then
      micromamba env create --file environment.yml -n memfault
      micromamba activate memfault
    fi

    source .venv/bin/activate
  '';

  runScript = "$SHELL -c \"$MEMFAULT_LAUNCH_COMMAND\"";
}

{
  system,
  lib,
  fetchurl,
  makeWrapper,
  buildFHSEnv,
  runCommand,
}: let
  version = "23.3.1-1";

  src = fetchurl srcForSystem;
  srcForSystem =
    {
      "x86_64-linux" = {
        url = "https://github.com/conda-forge/miniforge/releases/download/${version}/Mambaforge-${version}-Linux-x86_64.sh";
        sha256 = "dbe92c011a1315b9626e2f93a165892f4b89177145bc350b3859a483a3642a24";
      };
      "x86_64-darwin" = {
        url = "https://github.com/conda-forge/miniforge/releases/download/${version}/Mambaforge-${version}-MacOSX-x86_64.sh";
        sha256 = "ee707e117c4eb54b7a02a0ba1b2fc2b60325ce6f767e76274e45dbe7743efa7d";
      };
      "aarch64-darwin" = {
        url = "https://github.com/conda-forge/miniforge/releases/download/${version}/Mambaforge-${version}-MacOSX-arm64.sh";
        sha256 = "1b07c1a231a18f21da6aac1abe87dd173ce141ce7612f06eab962eb9f8353a27";
      };
    }
    .${system}
    or (throw "Unsupported platform: ${system}");

  outdir = "$HOME/.mambaforge";

  mambaforge =
    runCommand "mambaforge-install" {nativeBuildInputs = [makeWrapper];}
    ''
      mkdir -p $out/bin
      cp ${src} $out/bin/mambaforge-installer.sh
      chmod +x $out/bin/mambaforge-installer.sh

      makeWrapper \
        $out/bin/mambaforge-installer.sh \
        $out/bin/mambaforge-install \
        --add-flags "-p \$1" \
        --add-flags "-b" \
        --add-flags "-s"
    '';
in
  buildFHSEnv {
    name = "mambaforge-shell";
    targetPkgs = pkgs: [mambaforge pkgs.pokemonsay];
    profile = ''
      export PATH="$PATH:${outdir}/bin:${outdir}/condabin"

      if [ -f "${outdir}/etc/profile.d/mamba.sh" ]; then
        source ${outdir}/etc/profile.d/mamba.sh
      fi
      if ! command -v conda &> /dev/null; then
        echo "Conda not found, running mambaforge-install..."
        mambaforge-install ${outdir}
      fi

      source ${outdir}/etc/profile.d/mamba.sh

      eval "$(conda shell.zsh hook)"
      conda activate memfault || mamba env create --file environment.yml -n memfault
    '';

    runScript = "$SHELL -c \"$MEMFAULT_LAUNCH_COMMAND\"";

    meta = {
      description = "Mambaforge is a package manager for Python";
      homepage = "https://github.com/conda-forge/miniforge#mambaforge";
      platforms = with lib.platforms; [linux darwin];
      license = lib.licenses.bsd3;
    };
  }

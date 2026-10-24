{
  pkgs,
  lib,
  config,
  ...
}:
let
  stateDir = "${config.xdg.stateHome}/secret-scan";

  whereCredentialsLand = [
    ".aws"
    ".cache/doriath"
    ".claude"
    ".codex"
    ".config"
    ".docker"
    ".gnupg"
    ".kube"
    ".local/state/doriath"
    ".pulumi/credentials.json"
    ".ssh"
  ];

  dependencyAndAppCachePatterns = [
    "/node_modules/"
    "/\\.git/"
    "/\\.venv/"
    "/\\.cache/(go-build|pip|pnpm|yarn|npm)/"
    "/agents/[^/]+/home/(go|\\.cache|\\.local)/"
    "/(Cache|Code Cache|GPUCache|DawnCache|DawnGraphiteCache|DawnWebGPUCache|GrShaderCache|ShaderCache|Service Worker|IndexedDB|blob_storage|Session Storage|Local Storage|WebStorage|Crashpad|component_crx_cache|optimization_guide_model_store|Dictionaries|Extensions)/"
  ];

  trufflehogExcludes = pkgs.writeText "secret-scan-trufflehog-excludes" (
    lib.concatLines dependencyAndAppCachePatterns
  );
  betterleaksConfig = pkgs.writeText "secret-scan-betterleaks.toml" ''
    [extend]
    useDefault = true
    [[allowlists]]
    paths = [
    ${lib.concatMapStrings (re: "  '''${re}''',\n") dependencyAndAppCachePatterns}]
  '';

  secretScan = pkgs.writeShellApplication {
    name = "secret-scan";
    runtimeInputs = with pkgs; [
      betterleaks
      coreutils
      findutils
      jq
      libnotify
      trufflehog
    ];
    text = ''
      umask 077
      state="${stateDir}"
      mkdir -p "$state"
      known="$state/known.tsv"
      work=$(mktemp -d "''${XDG_RUNTIME_DIR:?}/secret-scan.XXXXXX")
      trap 'rm -rf "$work"' EXIT

      redact_betterleaks() { jq -c '(. // [])[] | {detector: .RuleID, file: .File}'; }
      redact_trufflehog() { jq -c '{detector: .DetectorName, file: .SourceMetadata.Data.Filesystem.file}'; }
      pulumi_credentials_are_plaintext() {
        [[ -f "$1" ]] && ! jq -e 'has("$pulumiSecureStore")' "$1" >/dev/null
      }

      case "''${1:-scan}" in
        new)
          if [[ -f "$state/new.tsv" ]]; then sed "s|$HOME|~|" "$state/new.tsv"; fi
          exit
          ;;
        verify)
          shift
          trufflehog filesystem "$@" --json --results=verified,unknown 2>/dev/null \
            | jq -c '{detector: .DetectorName, verified: .Verified, file: .SourceMetadata.Data.Filesystem.file, line: .SourceMetadata.Data.Filesystem.line}'
          exit
          ;;
      esac

      targets=()
      for target in ${lib.escapeShellArgs whereCredentialsLand}; do
        if [[ -e "$HOME/$target" ]]; then targets+=("$HOME/$target"); fi
      done
      while IFS= read -r -d "" dotfile; do targets+=("$dotfile"); done \
        < <(find "$HOME" -maxdepth 1 -type f -name '.*' -print0)

      for target in "''${targets[@]}"; do
        betterleaks dir "$target" --config ${betterleaksConfig} --no-banner --redact --exit-code 0 \
          --max-archive-depth 0 --report-format json --report-path - 2>/dev/null \
          | redact_betterleaks
      done >"$work/findings.jsonl"

      printf '%s\0' "''${targets[@]}" \
        | xargs -0 trufflehog filesystem --json --no-verification --concurrency=4 \
          --force-skip-binaries --force-skip-archives --exclude-paths=${trufflehogExcludes} 2>/dev/null \
        | redact_trufflehog >>"$work/findings.jsonl"

      cp "$work/findings.jsonl" "$state/latest.jsonl"
      jq -r '[.detector, .file] | @tsv' "$work/findings.jsonl" | sort -u >"$work/now.tsv"

      if [[ ! -e "$known" ]]; then
        cp "$work/now.tsv" "$known"
        notify-send --app-name=secret-scan "Secret scan baseline recorded" \
          "$(wc -l <"$known") findings. Later runs report only new ones."
      else
        new=$(comm -13 "$known" "$work/now.tsv")
        if [[ -n "$new" ]]; then
          sort -u "$known" "$work/now.tsv" -o "$known"
          printf '%s\n' "$new" | sed "s|^|$(date +%F)\t|" >>"$state/new.tsv"
          notify-send --urgency=critical --app-name=secret-scan \
            "$(printf '%s\n' "$new" | wc -l) new secret findings" \
            "$(printf '%s\n' "$new" | head -5 | sed "s|$HOME|~|")
      All of them: secret-scan new"
        fi
      fi

      if pulumi_credentials_are_plaintext "$HOME/.pulumi/credentials.json"; then
        notify-send --urgency=critical --app-name=secret-scan "Pulumi credentials are in plaintext" \
          "A Pulumi CLI without the OS credential store rewrote ~/.pulumi/credentials.json. Run pulumi login to encrypt it again."
      fi
    '';
  };
in
{
  home.packages = [ secretScan ];

  systemd.user = {
    services.secret-scan = {
      Unit.Description = "Redacted secret scan of agent transcripts and credential stores";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe secretScan;
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };
    timers.secret-scan = {
      Unit.Description = "Daily redacted secret scan";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

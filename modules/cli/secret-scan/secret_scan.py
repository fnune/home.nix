import argparse
import json
import os
import re
import shlex
import subprocess
from collections.abc import Iterable, Iterator
from dataclasses import asdict, dataclass
from datetime import date
from pathlib import Path
from typing import TypedDict, cast


class Settings(TypedDict):
    state_dir: str
    credential_locations: list[str]
    betterleaks: str
    betterleaks_config: str
    trufflehog: str
    trufflehog_detectors: list[str]
    trufflehog_ignored_secret: str
    trufflehog_excludes: str
    notify_send: str


class BetterleaksLeak(TypedDict):
    RuleID: str
    File: str


class TrufflehogFilesystem(TypedDict):
    file: str


class TrufflehogData(TypedDict):
    Filesystem: TrufflehogFilesystem


class TrufflehogSource(TypedDict):
    Data: TrufflehogData


class TrufflehogResult(TypedDict):
    DetectorName: str
    Raw: str
    SourceMetadata: TrufflehogSource


class RecordEntry(TypedDict):
    detector: str
    file: str
    first_seen: str
    acknowledged: bool


class Arguments(argparse.Namespace):
    command: str | None = None
    paths: list[str] = []


def read_json(text: str) -> object:
    return cast(object, json.loads(text))


SETTINGS = cast(Settings, read_json(Path("@settings@").read_text()))
HOME = Path.home()
STATE_DIR = Path(SETTINGS["state_dir"])
FINDINGS = STATE_DIR / "findings.json"
LATEST = STATE_DIR / "latest.jsonl"
PLAINTEXT_PULUMI_CREDENTIALS = (
    "A Pulumi CLI without the OS credential store rewrote ~/.pulumi/credentials.json. "
    + "Run pulumi login to encrypt it again."
)


@dataclass(frozen=True, order=True)
class Finding:
    detector: str
    file: str


@dataclass
class Record:
    detector: str
    file: str
    first_seen: str
    acknowledged: bool

    @property
    def finding(self) -> Finding:
        return Finding(self.detector, self.file)


Records = dict[Finding, Record]


def tilde(path: str) -> str:
    home = str(HOME)
    if path == home or path.startswith(home + "/"):
        return "~" + path[len(home) :]
    return path


def load_records() -> Records | None:
    if not FINDINGS.exists():
        return None
    entries = cast(list[RecordEntry], read_json(FINDINGS.read_text()))
    records = (Record(**entry) for entry in entries)
    return {record.finding: record for record in records}


def save_records(records: Records) -> None:
    ordered = sorted(records.values(), key=lambda record: record.finding)
    pending = FINDINGS.with_suffix(".pending")
    _ = pending.write_text(json.dumps([asdict(record) for record in ordered], indent=1))
    _ = pending.replace(FINDINGS)


def notify(summary: str, body: str, *, critical: bool = False) -> None:
    urgency = "critical" if critical else "normal"
    command = [
        SETTINGS["notify_send"],
        "--app-name=secret-scan",
        f"--urgency={urgency}",
    ]
    _ = subprocess.run([*command, summary, body], check=False)


def is_chromium_profile(path: Path) -> bool:
    return (path / "Local State").exists()


def scan_targets() -> list[Path]:
    targets: list[Path] = []
    for location in SETTINGS["credential_locations"]:
        path = HOME / location
        if path.is_dir():
            entries = sorted(path.iterdir())
            targets += [entry for entry in entries if not is_chromium_profile(entry)]
        elif path.exists():
            targets.append(path)
    dotfiles = sorted(HOME.glob(".*"))
    targets += [path for path in dotfiles if path.is_file() and not path.is_symlink()]
    return targets


def betterleaks(targets: Iterable[Path]) -> Iterator[Finding]:
    for target in targets:
        report = subprocess.run(
            [
                SETTINGS["betterleaks"],
                "dir",
                str(target),
                f"--config={SETTINGS['betterleaks_config']}",
                "--no-banner",
                "--redact",
                "--exit-code=0",
                "--max-archive-depth=0",
                "--report-format=json",
                "--report-path=-",
            ],
            capture_output=True,
            text=True,
            check=False,
        ).stdout
        leaks = cast(list[BetterleaksLeak] | None, read_json(report or "null"))
        for leak in leaks or []:
            yield Finding(leak["RuleID"], leak["File"])


def trufflehog(targets: Iterable[Path]) -> Iterator[Finding]:
    output = subprocess.run(
        [
            SETTINGS["trufflehog"],
            "filesystem",
            *map(str, targets),
            "--json",
            "--no-verification",
            "--concurrency=4",
            "--force-skip-binaries",
            "--force-skip-archives",
            f"--include-detectors={','.join(SETTINGS['trufflehog_detectors'])}",
            f"--exclude-paths={SETTINGS['trufflehog_excludes']}",
        ],
        capture_output=True,
        text=True,
        check=False,
    ).stdout
    ignored = re.compile(SETTINGS["trufflehog_ignored_secret"])
    for line in output.splitlines():
        result = cast(TrufflehogResult, read_json(line))
        if ignored.search(result["Raw"]):
            continue
        file = result["SourceMetadata"]["Data"]["Filesystem"]["file"]
        yield Finding(result["DetectorName"], file)


def ack_command(finding: Finding) -> str:
    return f"secret-scan ack {shlex.quote(tilde(finding.file))}"


def abbreviate(path: str) -> str:
    parts = tilde(path).split("/")
    if len(parts) <= 6:
        return "/".join(parts)
    return "/".join([*parts[:5], "…", parts[-1]])


def report_new(findings: list[Finding]) -> None:
    for finding in findings:
        print(f"{finding.detector}\t{tilde(finding.file)}\n  {ack_command(finding)}")
    shown = [
        f"{finding.detector} in {abbreviate(finding.file)}" for finding in findings[:5]
    ]
    hidden = len(findings) - len(shown)
    notify(
        f"{len(findings)} possible secrets in files",
        "\n".join(
            [
                *shown,
                *([f"and {hidden} more"] if hidden else []),
                "",
                "See full paths: secret-scan new",
                "If real: rotate the secret and delete the file",
                "If not: secret-scan ack",
            ]
        ),
        critical=True,
    )


def pulumi_credentials_are_plaintext() -> bool:
    path = HOME / ".pulumi" / "credentials.json"
    if not path.is_file():
        return False
    credentials = cast(dict[str, object], read_json(path.read_text()))
    return "$pulumiSecureStore" not in credentials


def scan() -> None:
    targets = scan_targets()
    current = {*betterleaks(targets), *trufflehog(targets)}
    _ = LATEST.write_text(
        "".join(json.dumps(asdict(finding)) + "\n" for finding in sorted(current))
    )

    today = date.today().isoformat()
    records = load_records()
    if records is None:
        save_records(
            {
                finding: Record(finding.detector, finding.file, today, True)
                for finding in current
            }
        )
        notify(
            "Secret scan baseline recorded",
            f"{len(current)} findings. Later runs report only new ones.",
        )
    elif new := sorted(current - records.keys()):
        records.update(
            {
                finding: Record(finding.detector, finding.file, today, False)
                for finding in new
            }
        )
        save_records(records)
        report_new(new)

    if pulumi_credentials_are_plaintext():
        notify(
            "Pulumi credentials are in plaintext",
            PLAINTEXT_PULUMI_CREDENTIALS,
            critical=True,
        )


def unacknowledged(records: Records) -> list[Record]:
    pending = (record for record in records.values() if not record.acknowledged)
    return sorted(pending, key=lambda record: (record.first_seen, record.finding))


def show_new() -> None:
    for record in unacknowledged(load_records() or {}):
        print(
            f"{record.first_seen}\t{record.detector}\t{tilde(record.file)}\n  {ack_command(record.finding)}"
        )


def ack(prefixes: list[str]) -> None:
    records = load_records() or {}
    expanded = tuple(os.path.expanduser(prefix) for prefix in prefixes)
    matched = [
        record
        for record in unacknowledged(records)
        if not expanded or record.file.startswith(expanded)
    ]
    for record in matched:
        record.acknowledged = True
    save_records(records)
    print(f"Acknowledged {len(matched)} findings.")


def verify(paths: list[str]) -> None:
    command = [
        SETTINGS["trufflehog"],
        "filesystem",
        *paths,
        "--json",
        "--results=verified,unknown",
    ]
    os.execv(command[0], command)


def parse_arguments() -> Arguments:
    parser = argparse.ArgumentParser(
        prog="secret-scan", description="Redacted secret scan of credential stores."
    )
    commands = parser.add_subparsers(dest="command")
    _ = commands.add_parser(
        "scan", help="scan and report findings not seen before (default)"
    )
    _ = commands.add_parser("new", help="list unacknowledged findings")
    ack_parser = commands.add_parser(
        "ack", help="acknowledge findings, all of them without paths"
    )
    _ = ack_parser.add_argument(
        "paths", nargs="*", help="file or directory prefixes, ~ allowed"
    )
    verify_parser = commands.add_parser(
        "verify", help="check findings in paths against their services"
    )
    _ = verify_parser.add_argument("paths", nargs="+")
    return parser.parse_args(namespace=Arguments())


def main() -> None:
    _ = os.umask(0o077)
    STATE_DIR.mkdir(parents=True, exist_ok=True)

    arguments = parse_arguments()
    match arguments.command:
        case "new":
            show_new()
        case "ack":
            ack(arguments.paths)
        case "verify":
            verify(arguments.paths)
        case _:
            scan()


if __name__ == "__main__":
    main()

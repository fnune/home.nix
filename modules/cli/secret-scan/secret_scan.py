import argparse
import json
import os
import re
import shlex
import subprocess
from collections.abc import Iterator
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import TypedDict, cast, override


class Settings(TypedDict):
    state_dir: str
    transcripts: list[str]
    unexpected_credential_files: list[str]
    plaintext_credential_patterns: dict[str, str]
    trufflehog: str
    notify_send: str


class TrufflehogFilesystem(TypedDict):
    file: str
    line: int


class TrufflehogData(TypedDict):
    Filesystem: TrufflehogFilesystem


class TrufflehogSource(TypedDict):
    Data: TrufflehogData


class TrufflehogResult(TypedDict):
    DetectorName: str
    SourceMetadata: TrufflehogSource


SETTINGS = cast(Settings, json.loads(Path("@settings@").read_text()))
HOME = Path.home()
FINDINGS = Path(SETTINGS["state_dir"]) / "findings-v2.json"
DORIATH_AGENT_COMMIT = re.compile(r"(/\.cache/doriath/agents/[^/]+)@[0-9a-f]+(?=/)")


def without_doriath_commit(path: str) -> str:
    return DORIATH_AGENT_COMMIT.sub(r"\1@*", path)


def tilde(path: str) -> str:
    return "~" + path[len(str(HOME)) :] if path.startswith(f"{HOME}/") else path


@dataclass(frozen=True, order=True)
class Finding:
    detector: str
    file: str
    line: int

    def __post_init__(self) -> None:
        object.__setattr__(self, "file", without_doriath_commit(self.file))

    @override
    def __str__(self) -> str:
        return f"{self.detector} in {tilde(self.file)}:{self.line}"


Records = dict[Finding, bool]


def load_records() -> Records:
    if not FINDINGS.exists():
        return {}
    entries = cast(list[dict[str, str | int]], json.loads(FINDINGS.read_text()))
    return {
        Finding(str(e["detector"]), str(e["file"]), int(e["line"])): bool(
            e["acknowledged"]
        )
        for e in entries
    }


def save_records(records: Records) -> None:
    entries = [asdict(f) | {"acknowledged": a} for f, a in sorted(records.items())]
    pending = FINDINGS.with_suffix(".pending")
    _ = pending.write_text(json.dumps(entries, indent=1))
    _ = pending.replace(FINDINGS)


def live_secrets_in_transcripts() -> Iterator[Finding]:
    paths = [str(p) for pattern in SETTINGS["transcripts"] for p in HOME.glob(pattern)]
    if not paths:
        return
    output = subprocess.run(
        [
            SETTINGS["trufflehog"],
            "filesystem",
            *paths,
            "--json",
            "--results=verified",
            "--concurrency=4",
            "--force-skip-binaries",
            "--force-skip-archives",
        ],
        capture_output=True,
        text=True,
        check=True,
    ).stdout
    for line in output.splitlines():
        result = cast(TrufflehogResult, json.loads(line))
        source = result["SourceMetadata"]["Data"]["Filesystem"]
        yield Finding(result["DetectorName"], source["file"], source["line"])


def credential_stores() -> Iterator[Finding]:
    for name in SETTINGS["unexpected_credential_files"]:
        if (HOME / name).exists():
            yield Finding("credential-file", str(HOME / name), 0)
    for name, pattern in SETTINGS["plaintext_credential_patterns"].items():
        path = HOME / name
        lines = path.read_text(errors="replace").splitlines() if path.is_file() else []
        matches = (n for n, line in enumerate(lines, 1) if re.search(pattern, line))
        if (n := next(matches, None)) is not None:
            yield Finding("plaintext-credentials", str(path), n)


def notify(new: list[Finding]) -> None:
    more = [f"and {len(new) - 5} more"] if len(new) > 5 else []
    body = [*map(str, new[:5]), *more, "", "See all: secret-scan new"]
    body += ["If real: rotate the secret", "If not: secret-scan ack"]
    _ = subprocess.run(
        [
            SETTINGS["notify_send"],
            "--app-name=secret-scan",
            "--urgency=critical",
            f"{len(new)} possible leaked secrets",
            "\n".join(body),
        ],
        check=False,
    )


def scan() -> None:
    records = load_records()
    current = {*live_secrets_in_transcripts(), *credential_stores()}
    save_records({f: records.get(f, False) for f in current})
    new = sorted(current - records.keys())
    if new:
        print(*new, sep="\n")
        notify(new)


def show_new() -> None:
    for finding, acknowledged in sorted(load_records().items()):
        if not acknowledged:
            print(f"{finding}\n  secret-scan ack {shlex.quote(tilde(finding.file))}")


def ack(prefixes: list[str]) -> None:
    records = load_records()
    expanded = tuple(without_doriath_commit(os.path.expanduser(p)) for p in prefixes)
    matched = [f for f, a in records.items() if not a and f.file.startswith(expanded)]
    save_records(records | dict.fromkeys(matched, True))
    print(f"Acknowledged {len(matched)} findings.")


def main() -> None:
    parser = argparse.ArgumentParser(
        prog="secret-scan",
        description="Redacted scan of agent transcripts and credential stores.",
    )
    commands = parser.add_subparsers(dest="command")
    _ = commands.add_parser("scan", help="scan and report new findings (default)")
    _ = commands.add_parser("new", help="list unacknowledged findings")
    ack_parser = commands.add_parser("ack", help="acknowledge findings under paths")
    _ = ack_parser.add_argument("paths", nargs="*", default=[""], help="~ allowed")
    arguments = parser.parse_args()

    _ = os.umask(0o077)
    FINDINGS.parent.mkdir(parents=True, exist_ok=True)
    match cast(str | None, arguments.command):
        case "new":
            show_new()
        case "ack":
            ack(cast(list[str], arguments.paths))
        case _:
            scan()


if __name__ == "__main__":
    main()

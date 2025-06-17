#!/usr/bin/env python3

import json
import subprocess
import sys
from dataclasses import asdict, dataclass, field
from datetime import datetime
from pathlib import Path
from typing import cast


@dataclass
class SessionState:
    feature: str
    repo_name: str
    repo_root: str
    worktree_path: str
    instructions_file: str
    created_at: str
    tmux_session: str


@dataclass
class AISessionManager:
    session_state_dir: Path = Path.home() / ".aisessions"
    claude_path: str = "claude"
    instructions_template: Path = Path(__file__).parent / "aisession-instructions.md"

    allowed_bash_commands: list[str] = field(default_factory=lambda: [
        "git:*",
        "npm:*",
        "yarn:*",
        "python:*",
        "cargo:*",
        "make:*",
    ])
    allowed_file_tools: list[str] = field(default_factory=lambda: ["Edit", "Read", "Write", "MultiEdit"])
    allowed_search_tools: list[str] = field(default_factory=lambda: ["Glob", "Grep", "LS"])
    allowed_planning_tools: list[str] = field(default_factory=lambda: ["Task", "TodoRead", "TodoWrite"])

    @property
    def allowed_tools_str(self) -> str:
        """Build the --allowedTools argument string."""
        bash_tools = [f"Bash({cmd})" for cmd in self.allowed_bash_commands]
        all_tools = (
            bash_tools
            + self.allowed_file_tools
            + self.allowed_search_tools
            + self.allowed_planning_tools
        )
        return ",".join(all_tools)

    def check_dependencies(self) -> None:
        """Check if required tools are available."""
        required_tools = ["git", "tmux", "claude"]
        missing_tools: list[str] = []

        for tool in required_tools:
            if subprocess.run(["which", tool], capture_output=True).returncode != 0:
                missing_tools.append(tool)

        if missing_tools:
            print(f"Error: Missing required tools: {', '.join(missing_tools)}")
            sys.exit(1)

    def get_repo_info(self) -> tuple[str, str, str]:
        """Get repository information."""
        try:
            _ = subprocess.run(
                ["git", "rev-parse", "--is-inside-work-tree"],
                capture_output=True,
                text=True,
                check=True,
            )
        except subprocess.CalledProcessError:
            print("Error: Must be run from inside a git repository")
            sys.exit(1)

        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            check=True,
        )
        repo_root = result.stdout.strip()
        repo_name = Path(repo_root).name
        parent_dir = str(Path(repo_root).parent)

        return repo_root, repo_name, parent_dir

    def create_worktree(self, feature: str, repo_name: str, parent_dir: str) -> str:
        """Create a new git worktree for the AI session."""
        worktree_path = f"{parent_dir}/{repo_name}-{feature}"
        branch = f"ai/{feature}"

        print(f"Creating worktree at: {worktree_path}")
        print(f"Branch: {branch}")

        try:
            _ = subprocess.run(
                ["git", "worktree", "add", worktree_path, "-b", branch], check=True
            )
        except subprocess.CalledProcessError as e:
            print(f"Error creating worktree: {e}")
            sys.exit(1)

        return worktree_path

    def setup_session_state(
        self,
        feature: str,
        instructions_file: str,
        repo_name: str,
        repo_root: str,
        worktree_path: str,
    ) -> Path:
        """Save session state for resuming later."""
        _ = self.session_state_dir.mkdir(exist_ok=True)

        state = SessionState(
            feature=feature,
            repo_name=repo_name,
            repo_root=repo_root,
            worktree_path=worktree_path,
            instructions_file=str(Path(instructions_file).resolve()),
            created_at=datetime.now().isoformat(),
            tmux_session=f"ai/{feature}",
        )

        state_file = self.session_state_dir / f"{feature}.json"
        with open(state_file, "w") as f:
            json.dump(asdict(state), f, indent=2)

        return state_file

    def create_claude_instructions(
        self, instructions_file: str, worktree_path: str
    ) -> str:
        """Create comprehensive instructions for Claude Code."""
        claude_instructions_path = f"{worktree_path}/.aisession-instructions.md"

        try:
            with open(self.instructions_template, "r") as f:
                base_instructions = f.read()
        except FileNotFoundError:
            print(
                f"Error: Instructions template not found at {self.instructions_template}"
            )
            sys.exit(1)

        try:
            with open(instructions_file, "r") as f:
                original_instructions = f.read()
        except FileNotFoundError:
            print(f"Error: Instructions file '{instructions_file}' not found")
            sys.exit(1)

        with open(claude_instructions_path, "w") as f:
            _ = f.write(base_instructions + original_instructions)

        return claude_instructions_path

    def start_tmux_session(
        self, session_name: str, worktree_path: str, claude_instructions: str
    ) -> None:
        """Start a new tmux session with Claude Code."""
        print(f"Starting tmux session: {session_name}")
        print(f"Worktree: {worktree_path}")
        print(f"Instructions: {claude_instructions}")

        _ = subprocess.run(
            ["tmux", "new-session", "-d", "-s", session_name, "-c", worktree_path],
            check=True,
        )

        _ = subprocess.run(
            [
                "tmux",
                "send-keys",
                "-t",
                session_name,
                f"{self.claude_path} --allowedTools \"{self.allowed_tools_str}\" '{claude_instructions}'",
                "Enter",
            ],
            check=True,
        )

        _ = subprocess.run(["tmux", "attach-session", "-t", session_name])

    def start_new_session(self, feature: str, instructions_file: str) -> None:
        """Start a new AI coding session."""
        if not Path(instructions_file).exists():
            print(f"Error: Instructions file '{instructions_file}' not found")
            sys.exit(1)

        repo_root, repo_name, parent_dir = self.get_repo_info()
        worktree_path = self.create_worktree(feature, repo_name, parent_dir)

        _ = self.setup_session_state(
            feature, instructions_file, repo_name, repo_root, worktree_path
        )
        claude_instructions = self.create_claude_instructions(
            instructions_file, worktree_path
        )

        session_name = f"ai/{feature}"
        self.start_tmux_session(session_name, worktree_path, claude_instructions)

    def resume_session(self, feature: str) -> None:
        """Resume an existing AI coding session."""
        state_file = self.session_state_dir / f"{feature}.json"

        if not state_file.exists():
            print(f"Error: No saved session found for feature '{feature}'")
            print("Available sessions:")
            self.list_sessions()
            sys.exit(1)

        with open(state_file, "r") as f:
            state_data = cast(dict[str, str], json.load(f))

        state = SessionState(**state_data)

        if not Path(state.worktree_path).exists():
            print(f"Error: Worktree path '{state.worktree_path}' no longer exists")
            sys.exit(1)

        claude_instructions = f"{state.worktree_path}/.aisession-instructions.md"

        result = subprocess.run(
            ["tmux", "has-session", "-t", state.tmux_session], capture_output=True
        )

        if result.returncode == 0:
            print(f"Resuming existing tmux session: {state.tmux_session}")
            _ = subprocess.run(["tmux", "attach-session", "-t", state.tmux_session])
        else:
            print(
                f"Creating new tmux session for existing worktree: {state.tmux_session}"
            )
            self.start_tmux_session(
                state.tmux_session, state.worktree_path, claude_instructions
            )

    def list_sessions(self) -> None:
        """List all available AI coding sessions."""
        print("Available AI coding sessions:")

        if not self.session_state_dir.exists():
            print("  (none)")
            return

        session_files = list(self.session_state_dir.glob("*.json"))
        if not session_files:
            print("  (none)")
            return

        for state_file in session_files:
            try:
                with open(state_file, "r") as f:
                    state_data = cast(dict[str, str], json.load(f))
                    state = SessionState(**state_data)

                feature = state_file.stem
                created = state.created_at
                worktree = state.worktree_path
                exists = "✅" if Path(worktree).exists() else "❌"

                print(f"  {feature} (created: {created}) {exists}")
            except (json.JSONDecodeError, KeyError):
                print(f"  {state_file.stem} (corrupted state file)")

    def usage(self) -> None:
        """Print usage information."""
        print("Usage: aisession <FEATURE> <path-to-markdown-instructions>")
        print("       aisession --resume <FEATURE>")
        print("       aisession --list")
        print("")
        print("Examples:")
        print("  aisession user-auth ./tasks/implement-auth.md")
        print("  aisession --resume user-auth")
        print("  aisession --list")

    def main(self) -> None:
        """Main entry point."""
        self.check_dependencies()

        if len(sys.argv) < 2:
            self.usage()
            sys.exit(1)

        command = sys.argv[1]

        if command == "--resume":
            if len(sys.argv) < 3:
                print("Error: Feature name required for --resume")
                self.usage()
                sys.exit(1)
            self.resume_session(sys.argv[2])
        elif command == "--list":
            self.list_sessions()
        elif command in ["--help", "-h"]:
            self.usage()
        else:
            if len(sys.argv) < 3:
                print("Error: Instructions file required")
                self.usage()
                sys.exit(1)
            self.start_new_session(sys.argv[1], sys.argv[2])


if __name__ == "__main__":
    manager = AISessionManager()
    manager.main()

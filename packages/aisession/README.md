# `aisession`

A tool for managing AI-assisted coding sessions using git worktrees and tmux.

## Usage

```bash
# Start new session
aisession <FEATURE> <path-to-markdown-instructions>

# Resume existing session
aisession --resume <FEATURE>

# List all sessions
aisession --list

# Show help
aisession --help
```

## Overview

`aisession` creates isolated git worktrees for feature development with Claude Code, managing the entire workflow from setup to cleanup.

## Expected Workflow

### 1. Start a New AI Coding Session

From within a git repository, start a new AI coding session:

```bash
# Create task instructions file
echo "# Implement User Authentication
- Add login/logout endpoints
- Create user registration form
- Add JWT token validation
- Write tests for auth flow" > auth-task.md

# Start AI session
aisession user-auth auth-task.md
```

This will:

- Create a new git worktree at `../your-repo-user-auth/`
- Create a new branch `ai/user-auth`
- Combine base instructions with your task file
- Launch tmux session with Claude Code
- Attach to the session automatically

### 2. Working in the Session

Inside the tmux session, Claude Code will:

- Have full context about the task from the combined instructions
- Be able to read, modify, and create files
- Make git commits with proper messages
- Run tests and check code quality
- Update progress in the original task file

### 3. Resume an Existing Session

If you exit and want to resume later:

```bash
aisession --resume user-auth
```

This will:

- Check if the worktree still exists
- Reattach to existing tmux session, or create a new one
- Restore the full context

### 4. List Active Sessions

See all your AI coding sessions:

```bash
aisession --list
```

Output:

```
Available AI coding sessions:
  user-auth (created: 2024-01-15T10:30:00) ✅
  api-refactor (created: 2024-01-14T15:45:00) ❌
```

### 5. Cleanup

When the feature is complete:

1. Merge the `ai/user-auth` branch into your main branch
2. Remove the worktree: `git worktree remove ../your-repo-user-auth`
3. Delete the session state (optional)

## File Structure

```
your-repo/
├── auth-task.md                    # Your task instructions
└── ...

your-repo-user-auth/                # Created worktree
├── .aisession-instructions.md      # Combined instructions
├── ... (your code)
└── ...

~/.aisessions/                      # Session state
└── user-auth.json                  # Session metadata
```

## Requirements

- `git` - For worktree management
- `tmux` - For session management
- `claude` - Claude Code CLI (must be in PATH)

## Workspace

Add this to your global .gitignore:

```gitignore
.aisession-instructions.md
```

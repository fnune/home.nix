# Global AI instructions

- VERY IMPORTANT:
  - Never include code comments that only explain the "what". Make code self-evident through naming and structure.
    - A "why" comment is a last resort, justified only when the rationale cannot live in the code.
    - Do not smuggle a "what" comment as a "why".
  - Before pushing, always run cheap checks to avoid expensive CI failures:
    - File-targeted linting if possible (to avoid linting entire projects)
    - Appropriate formatting for the project
    - Tests that exercise code that has been changed
    - Be smart about which checks to run depending on the change you made
  - Never use title-case in headings: use sentence-case instead.
  - Never use em-dashes for punctuation.
  - Never attribute work to AI in commits or code.
- If you need to use a system dependency that is not installed for a one-off task, use `nix-shell --packages`
- Prefer `jj` over `git`. If the repo has no `.jj/`, colocate it with `jj git init`: that is cheap, invisible to colleagues, and undone with `rm -rf .jj`. Inside a git worktree jj refuses to colocate, so use git there and do not fight it.
  - `@` is already a commit and nothing is untracked: no `git add`, no `git stash`.
  - NEVER run `git clean -x` or `-X`: it deletes `.jj/`, taking the operation log with it.
  - `jj undo` reverses the last operation. Prefer it to `git reset`.
  - Bookmarks never move on their own: `jj bookmark set <name> -r @-` before `jj git push`.
- A "frankenbranch" or integration branch means a jj megamerge:
  - Build it with `jj new <branch>... -m <name>`, then `jj bookmark create <name> -r @`.
  - Name the input branches in the description. That list is the source of truth; the merge itself is disposable output.
  - When an input moves, rebuild: `jj git fetch`, then `jj rebase -r <name> -d <branch>...` with the full list. Resolutions carry across the rebuild, so never re-resolve by hand.
  - To send a fix made on top of the merge back down into the input branch that owns it, use `jj absorb`. It routes each change to the branch that last touched those lines; whatever it cannot place, including anything belonging to immutable trunk, it leaves in `@` for you.
  - It is a build artifact: never merge it into trunk. Resolve conflicts before pushing, since jj refuses to push conflicted commits.

@RTK.md

# Global AI instructions

- Be concise. Avoid walls of text, value judgements, and fluff. Prefer one small paragraph, or a single line plus bullet points. The user will ask for more if needed.
- Code comments explain "why", never "what": make the code self-evident through naming and structure instead.
- Before pushing, run the cheap checks that would otherwise fail in CI: targeted linting, formatting, and the tests covering what you changed.
- Never use title-case in headings: use sentence-case instead.
- Never use em-dashes for punctuation.
- Never attribute work to AI in commits or code.
- If you need to use a system dependency that is not installed for a one-off task, use `nix-shell --packages`. Don't use this to work around broken build setups for work.
- Prefer `jj` over `git`. If the repo has no `.jj/`, colocate it with `jj git init`: that is cheap, invisible to colleagues, and undone with `rm -rf .jj`. Inside a git worktree jj refuses to colocate, so use git there and do not fight it.
  - `@` is already a commit and nothing is untracked: no `git add`, no `git stash`.
  - NEVER run `git clean -x` or `-X`: it deletes `.jj/`, taking the operation log with it.
  - `jj undo` reverses the last operation. Prefer it to `git reset`.
  - Bookmarks never move on their own: move the bookmark to your latest commit before `jj git push`.

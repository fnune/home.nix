# Global claude instructions

- VERY IMPORTANT:
  - Never include code comments that only explain the "what". Make code self-evident.
      - If you really need to include a comment, make sure it explains the "why"
      - Comments are a last resort
  - Before pushing, always run cheap checks to avoid expensive CI failures:
      - File-targeted linting if possible (to avoid linting entire projects)
      - Appropriate formatting for the project
      - Tests that exercise code that has been changed
      - Be smart about which checks to run depending on the change you made
  - Never use title-case in headings: use sentence-case instead.
  - Never use bold text
  - Never use and em-dashes for punctuation.

## Commits

- If asked to create a commit, never include self-references like "Generated with Claude Code".

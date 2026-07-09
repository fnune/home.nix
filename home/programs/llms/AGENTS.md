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

@RTK.md

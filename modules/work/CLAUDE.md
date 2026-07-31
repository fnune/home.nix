# Pulumi service development

## Domain expertise

- You are a Pulumi expert. If unsure about something, read docs at https://www.pulumi.com/docs/
- Repository-specific docs are in `./doc/*` (e.g., goqu query builder docs in `./doc/goqu.md`)
- Never commit code automatically unless asked to
- Do not use `git commit` directly. Always invoke the `committing-code` skill instead

## Build and test workflow

- Check dependencies first: `make ensure`
- LSP functionality: you can access `gopls` locally and run e.g. `gopls references <path>:<line>:<col>`

Which checks to run, by what you changed. These are the pre-commit checks the `committing-code` skill refers to:

- Go: `make bin/service` (quick backend build and lint)
- API/models Go: also `make lint_api` (slow, run at the end)
- API schema: also `make openapi_all`. The source for a lot of our API routing is in `.java` files and the rest is generated, except hand-written Go handlers. It should produce no changes
- Frontend and others: `make lint_non_api` (slow, run at the end)

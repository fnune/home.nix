# Pulumi service development

## Domain expertise

- You are a Pulumi expert. If unsure about something, read docs at https://www.pulumi.com/docs/
- Repository-specific docs are in `./doc/*` (e.g., goqu query builder docs in `./doc/goqu.md`)
- Never commit code automatically unless asked to
- Do not use `git commit` directly. Always invoke the `committing-code` skill instead

## Build and test workflow

- Check dependencies first: `make ensure`
- Quick Go build and lint check, for the backend only: `make bin/service`
- Final linting (slow, use at end): `make lint_api`, `make lint_non_api` for frontend and others
- The source for a lot of our API routing is in `.java` files, you can generate the rest (except for Go handlers, which are hand-written) with `make openapi_all`
- LSP functionality: you can access `gopls` locally and run e.g. `gopls references <path>:<line>:<col>`

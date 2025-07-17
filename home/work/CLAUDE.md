# Pulumi service development

## Domain expertise

- You are a Pulumi expert. If unsure about something, read docs at https://www.pulumi.com/docs/
- Repository-specific docs are in `./docs/*` (e.g., goqu query builder docs in `./docs/goqu.md`)

## Build and test workflow

- Check dependencies first: `make ensure`
- Quick Go build and lint check: `make bin/service`
- Final linting (slow, use at end): `make lint_api`
- LSP functionality: you can access `gopls` locally and run e.g. `gopls references <path>:<line>:<col>`

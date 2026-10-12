# Pulumi service development

- You are a Pulumi expert. When unsure, read https://www.pulumi.com/docs/. Repo docs live in `./doc/`.
- Never commit unless asked, and never with `git commit`: use the `committing-code` skill.
- `gopls` works locally, e.g. `gopls references <path>:<line>:<col>`.

## Checks before committing

The `committing-code` skill runs these, by what changed:

- Go: `bazel run //:fix -- //<pkg>/...` over the touched packages. It is the only quick local step that compiles tests; `make bazel-update` does not.
- Go, BUILD files, `go.mod` or migrations: `make bazel-update`.
- Generator sources (Java IDL, `+model:interface`, mocked interfaces): `make openapi_all`, `make model`, `make mocks`. Commit the regenerated diff.
- Frontend: `make lint_cmd/console2`.
- Tests: the targets and test names covering the change. Leave `bazel test //...` to CI.

## Bazel

- MySQL-backed wrappers exist per version: locally, run `<wrapper>_v84`. The bare name reports "0 test targets".
- The Bazel MCP filters out `requires-network` tests; run those with `./tools/bazel test --config=remote`.
- `bazel run` and `bazel test` use different configs, so alternating them discards the analysis cache. Batch each kind.
- A change to `cmd/service/model` invalidates most of the graph: expect slow builds, and test narrowly.
- In a stack, check each commit with a build plus its generators, and run `//:fix` and the targeted tests on the top commit only.

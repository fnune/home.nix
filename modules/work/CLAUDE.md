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

## Iterating quickly

- One Bazel or `make` command per worktree at a time. Two at once fight over the output base lock, and generators running side by side delete or clobber each other's files. Stop a stale run before starting the next, and `git checkout -- .` the worktree before checking out another commit.
- Pick the narrowest generator. An IDL change needs `make openapi_go openapi_typescript openapi_spec`; `make openapi_all` also rebuilds the five SDKs and takes minutes. A `+model:interface` change needs `make model mocks` only.
- New generated TypeScript proxy files need `bazel run //cmd/console2:write_shard_inputs`, or `//cmd/console2:write_shard_inputs_test` fails in CI.
- Anchor `--test_filter`: `'^(TestA|TestB)$'`. One stray `|Test` matches everything and runs whole sharded suites.
- From a jj workspace: check the commit out by hash in the git worktree, run the generators there, `git diff` into a patch, and `patch -p1` it into the jj commit. Never fold a diff from a run that was interrupted or overlapped.
- Never `pkill -f` a pattern that also matches your own command line: it kills the shell running it.
- To make a call mockable in tests, use a `+model:interface` method, not a new `Config(...)` or `DependsOn(...)` on a generated API. A new config binder is required, so every test that builds that API must supply it, and the ones that do not panic.
- Code gated on an application migration (`CheckStatusOfMigration`) stays closed in a freshly started test service until the migration has run, and a negative check is cached for 10 minutes. Tests against a live service must wait for it.
- Before pushing, run `//:fix` over the touched packages and the tests that cover the change. A CI round takes about 15 minutes; a local targeted run, 2 to 5.
- Review stack image builds: if `bazel run //tools/docker:publish_*` crashes with `... is not under .../execroot/_main, cannot relativize`, add `startup --noexperimental_remote_repo_contents_cache` to the slot's `user.bazelrc`.

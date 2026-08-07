# automation-core

This branch exists to host reusable GitHub Actions workflows shared across `rancher/kuberlr-kubectl`'s branches, so CI/CD logic is defined once instead of copy-pasted per branch.

Most workflows here are triggered only via `workflow_call`. The actual branches keep a thin wrapper in their own `.github/workflows/` that declares the real trigger (`push`, `pull_request`, etc.) and delegates to the matching file on this branch, e.g.:

PS: Any step that reads files from the repo (scripts, Dockerfile, charts, ...) runs against the *caller's* checkout.

## Workflows

| File | Purpose |
|------|---------|
| `ci.yml` | Runs `make ci` on push/PR |
| `e2e-ci.yaml` | Builds the image and runs the e2e suite against a k3d cluster |
| `cleanup.yml` | Deletes a PR's branch after merge for auto-created PRs |
| `fossa.yml` | Runs FOSSA license/vulnerability scanning |
| `deploy-workflows.yml` | Renders `workflow-templates/*.tmpl` and opens a PR against a target branch |

## Actions

| Action | Purpose |
|--------|---------|
| `check-semver` | Parses a tag's semver characteristics (prerelease / build metadata) |
| `compute-branch-tags` | Computes the rolling/static image tags for branch-head builds |

## workflow-templates/

Every workflow file that lives in a branch's `.github/workflows/` is generated from a template here — even the thin `workflow_call` wrappers, so nothing on `main`/`release/v*` is hand-edited.

## Deploying workflows

Actions → Deploy Workflows → Run workflow, with:

- `targetBranch` — e.g. `main`, `release/v7.x`
- `automationCoreRef` — defaults to `automation-core`; pin it to a tag if a branch shouldn't pick up changes automatically

It renders every `workflow-templates/*.tmpl`, checks the result is valid YAML, pushes a branch, and opens a PR against `targetBranch` using the default `GITHUB_TOKEN`.

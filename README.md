# automation-core

This branch exists to host reusable GitHub Actions workflows shared across `rancher/kuberlr-kubectl`'s branches, so CI/CD logic is defined once instead of copy-pasted per branch.

Each workflow here is triggered only via `workflow_call`. The actual branches keep a thin wrapper in their own `.github/workflows/` that declares the real trigger (`push`, `pull_request`, etc.) and delegates to the matching file on this branch, e.g.:

```yaml
jobs:
  ci:
    uses: rancher/kuberlr-kubectl/.github/workflows/ci.yml@automation-core
```

PS: Any step that reads files from the repo (scripts, Dockerfile, charts, ...) runs against the *caller's* checkout.

## Workflows

| File | Purpose |
|------|---------|
| `ci.yml` | Runs `make ci` on push/PR |
| `e2e-ci.yaml` | Builds the image and runs the e2e suite against a k3d cluster |
| `head-build.yml` | Publishes branch-head prerelease images |
| `release.yml` | Publishes tagged release images (public + prime registries) |
| `cleanup.yml` | Deletes a PR's branch after merge for auto-created PRs |
| `fossa.yml` | Runs FOSSA license/vulnerability scanning (`main` and `release/v7.x` only) |

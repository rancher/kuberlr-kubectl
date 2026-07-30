# Migrating `rancher/charts` packages

## How To: Migrate charts from `rancher/kubectl` to `rancher/kuberlr-kubectl`

### Migrating charts based on Rancher version


Since the new `kuberlr` based image targets Rancher minor versions, the chart migration process depends on the Rancher minor version the chart targets.

Refer to the table below (and maintained on the main [README.md](/README.md)) to identify the appropriate `rancher/kuberlr-kubectl` image version when replacing `rancher/kubectl`.

| `rancher/kuberlr-kubectl` Tag   | Rancher Tag (Branch) |
|---------------|----------------------|
| v3.Y.Z | 2.10.Z (main)        |
| v2.Y.Z | 2.9.Z (release/v2.9) |
| v1.Y.Z | 2.8.Z (release/v2.8) |

### Migrating charts from `rancher/shell`

Previously, some charts required `rancher/shell` instead of `rancher/kubectl` because the older `rancher/kubectl` image only included `kubectl` binary and lacked a full shell environment.

This isn't the case with `rancher/kuberlr-kubectl`. Unless the chart uses `rancher/shell` for the `helm` binary then it should be safe to switch to `rancher/kuberlr-kubectl`.

Refer to the table above and use the corresponding `rancher/kuberlr-kubectl` version. Ensure your QA process validates this aspect of the chart(s), usually related to upgrade jobs or similar tasks.
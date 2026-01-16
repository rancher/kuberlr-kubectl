# rancher/kuberlr-kubectl
A simple way to invoke the correct [kubectl](https://github.com/rancher/kubectl) version on a Rancher managed cluster using [kuberlr](https://github.com/flavio/kuberlr).

Images found at:

- https://hub.docker.com/r/rancher/kuberlr-kubectl
- https://github.com/rancher/kuberlr-kubectl/pkgs/container/kuberlr-kubectl

## Details
This repo produces a Rancher specific version of the `flavio/kuberlr` image.

  - This container is analogous to the current `rancher/kubectl` container, but based on [kuberlr](https://github.com/flavio/kuberlr)
  - Unlike `rancher/kubectl`, this image targets specific Rancher minor release branches.
  - Each release pre-bundles all necessary [kubectl](https://github.com/rancher/kubectl) versions supported by the Rancher version the release supports.

## Branches, Releases, and Rancher
| Branch              | Release Tag   | Rancher Tag (Branch)   |
|---------------------|---------------|------------------------|
| main (release/v7.x) | head (v7.Y.Z) | 2.14.Z (main)          |
| release/v6.x        | v6.Y.Z | 2.13.Z (release/v2.13) |
| release/v5.x        | v5.Y.Z        | 2.12.Z (release/v2.12) |
| release/v4.x        | v4.Y.Z        | 2.11.Z (release/v2.11) |
| release/v3.x        | v3.Y.Z        | 2.10.Z (release/v2.10) |

### Notes:
- Each minor Rancher release will get a `rancher/kuberlr-kubectl` branch:
  - Each branch will get an image tag major to match it.
  - This gives us full "Y" and "Z" control on versioning the component to target Rancher minors.
  - E.x. Rancher 2.10.x releases will get varying versions of 3.Y.Z

### Migration

See the dedicated [Migration's Doc](/docs/chart-migration.md) for specific details on migrating charts.

### Compatability

The base `flavio/kuberlr` image comes from the upstream repo and is essentially universally compatible like `kuberlr`.
However, for it to work it relies on an internet connection to fetch kubectl binaries on the fly.

In contrast, our `rancher/kuberlr-kubectl` bundles the necessary `kubectl` binaries into each image.
In this way the image is ready to work on any supported k8s versions for that Rancher release in an air-gap out the box.
Given that k8s provides a slight version drift, as the Rancher minor lifecycle progresses we reduce inclusion of older `kubectl` versions.


| Rancher Version | k8s min | k8s max | `kuberlr-kubectl` image |
|-----------------|---------|---------|------------------------|
| 2.14.x          | 1.33    | 1.35    | 3.y.z |
| 2.13.x          | 1.32    | 1.34    | 3.y.z |
| 2.12.x          | 1.31    | 1.33    | 3.y.z |
| 2.11.x          | 1.30    | 1.32    | 3.y.z |
| 2.10.x          | 1.28    | 1.31    | 3.y.z |


> Note: Over-time, as new `kuberlr` binaries are released we can still bump the Y or Z of each `rancher/kuberlr-kubectl` release to update all supported Rancher releases.
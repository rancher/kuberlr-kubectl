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

See a detailed summary in [VERSION file](VERSION.md).


## Migration

See the dedicated [Migration's Doc](/docs/chart-migration.md) for specific details on migrating charts.


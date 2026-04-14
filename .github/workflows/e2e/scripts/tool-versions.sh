#!/usr/bin/env bash
# tool-versions.sh — single source of truth for pinned CI tool versions and checksums.
# k3d and ORAS: Renovate auto-updates both version and checksums (github-release-attachments).

# renovate: datasource=github-release-attachments depName=k3d-io/k3d
K3D_VERSION="v5.8.3"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_amd64="dbaa79a76ace7f4ca230a1ff41dc7d8a5036a8ad0309e9c54f9bf3836dbe853e"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_arm64="0b8110f2229631af7402fb828259330985918b08fefd38b7f1b788a1c8687216"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_arm="c4ef4e8008edb55cf347d846a7fc70af319883f9a474167689bd8af04693401d"

# renovate: datasource=github-release-attachments depName=oras-project/oras
ORAS_VERSION="v1.2.0"
# renovate: datasource=github-release-attachments depName=oras-project/oras digestVersion=v1.2.0
ORAS_SHA256_amd64="5b3f1cbb86d869eee68120b9b45b9be983f3738442f87ee5f06b00edd0bab336"
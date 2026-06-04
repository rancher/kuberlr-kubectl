#!/bin/bash

set -e
set -x

# renovate: datasource=github-release-attachments depName=k3d-io/k3d
K3D_VERSION="v5.8.3"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_amd64="dbaa79a76ace7f4ca230a1ff41dc7d8a5036a8ad0309e9c54f9bf3836dbe853e"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_arm64="0b8110f2229631af7402fb828259330985918b08fefd38b7f1b788a1c8687216"
# renovate: datasource=github-release-attachments depName=k3d-io/k3d digestVersion=v5.8.3
K3D_SHA256_arm="c4ef4e8008edb55cf347d846a7fc70af319883f9a474167689bd8af04693401d"


# initArch discovers the architecture for this system.
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
    armv7*) ARCH="arm";;
    aarch64) ARCH="arm64";;
    x86_64) ARCH="amd64";;
  esac
}

initArch

expected_sha256_var="K3D_SHA256_${ARCH}"
expected_sha256="${!expected_sha256_var}"

if [[ -z "${expected_sha256}" ]]; then
  echo "No hardcoded SHA256 for arch ${ARCH} — run update-checksums.sh after bumping K3D_VERSION"
  exit 1
fi

echo "Downloading k3d@${K3D_VERSION}"
curl -sL --fail "https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}/k3d-linux-${ARCH}" > k3d

echo "${expected_sha256}  k3d" | sha256sum -c

chmod +x k3d
cp k3d /usr/local/bin/k3d

k3d version
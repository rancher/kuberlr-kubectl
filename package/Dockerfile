ARG BCI_VERSION=16.1
ARG GO_IMAGE=rancher/hardened-build-base:v1.26.4b1

# xx provides cross-compilation helpers so the builder always runs on the build
# machine's native arch while targeting TARGETPLATFORM.
FROM --platform=$BUILDPLATFORM rancher/mirrored-tonistiigi-xx:1.6.1 AS xx

# Single stage builds all kubectl versions listed in kubectl-versions.txt.
FROM --platform=$BUILDPLATFORM ${GO_IMAGE}  AS kubectl-builder
COPY --from=xx / /
ARG TARGETPLATFORM
RUN xx-go --wrap

WORKDIR /build
COPY kubectl-versions.txt .
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    set -e && \
    mkdir -p /kubectl-bins && \
    while read -r version; do \
        echo "==> Building kubectl ${version}"; \
        curl -fsSL \
            https://github.com/kubernetes/kubernetes/archive/refs/tags/${version}.tar.gz | \
            tar -xz && \
        cd kubernetes-${version#v} && \
        KUBE_GIT_VERSION=${version} \
        KUBE_GIT_COMMIT=unknown \
        KUBE_GIT_TREE_STATE=clean \
        KUBE_BUILD_PLATFORMS=$(xx-info os)/$(xx-info arch) \
        GOFLAGS="-tags=providerless" \
        CGO_ENABLED=0 \
        make WHAT=cmd/kubectl && \
        xx-verify --static _output/local/bin/$(xx-info os)/$(xx-info arch)/kubectl && \
        cp _output/local/bin/$(xx-info os)/$(xx-info arch)/kubectl /kubectl-bins/kubectl${version#v} && \
        cd /build && rm -rf kubernetes-${version#v}; \
    done < kubectl-versions.txt

FROM ghcr.io/flavio/kuberlr:v0.7.0 AS kuberlr
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final
FROM registry.suse.com/bci/bci-base:${BCI_VERSION} AS zypper

ARG TARGETPLATFORM
ARG TARGETARCH

# Creates the base dir for the target image, and hydrates it with the
# original contents of the final image.
RUN mkdir /chroot
COPY --from=final / /chroot/

# The final image does not contain zypper, --installroot is used to
# install all artefacts within a dir (/chroot) that can then be copied
# over to a scratch image.
RUN zypper --non-interactive refresh && \
    zypper --installroot /chroot --non-interactive update && \
    zypper --installroot /chroot -n rm busybox-vi busybox-links && \
    zypper --installroot /chroot -n in bash-completion && \
    zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/

# Pull in kuberlr bin and home dir (pre configured .kubrlr)
COPY --from=kuberlr /bin/kuberlr /chroot/bin/
RUN cd /chroot/bin && ln -s ./kuberlr ./kubectl
COPY --from=kuberlr /home/kuberlr /chroot/home/kuberlr

# Copy all kubectl binaries built from source
COPY --from=kubectl-builder /kubectl-bins/ /chroot/usr/bin/

# Disable ability to download kubectl due to air-gap support
RUN sed -i 's/AllowDownload = true/AllowDownload = false/' /chroot/home/kuberlr/.kuberlr/kuberlr.conf

# Setup kuberlr user and perms
RUN useradd -u 1000 -U kuberlr \
    && cp /etc/passwd /chroot/etc/passwd \
    && cp /etc/group /chroot/etc/group \
    && chown -R 1000:1000 /chroot/home/kuberlr

FROM scratch

COPY --from=zypper /chroot /

USER kuberlr
WORKDIR /home/kuberlr
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]

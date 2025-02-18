ARG BCI_VERSION=15.6
FROM ghcr.io/flavio/kuberlr:v0.5.3 AS kuberlr
FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final
FROM registry.suse.com/bci/bci-base:${BCI_VERSION} AS zypper

ARG TARGETPLATFORM
ARG TARGETARCH

# Creates the based dir for the target image, and hydrates it with the
# original contents of the final image.
RUN mkdir /chroot
COPY --from=final / /chroot/

# The final image does not contain zypper, --installroot is used to
# install all artefacts within a dir (/chroot) that can then be copied
# over to a scratch image.
RUN zypper --non-interactive refresh && \
    zypper --installroot /chroot -n rm busybox-vi busybox-links && \
    zypper --installroot /chroot -n in bash-completion && \
    zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/

# Pull in kuberlr bin and home dir (pre configured .kubrlr)
COPY --from=kuberlr /bin/kuberlr /chroot/bin/
RUN cd /chroot/bin && ln -s ./kuberlr ./kubectl
COPY --from=kuberlr /home/kuberlr /chroot/home/kuberlr
RUN sed -i 's/AllowDownload = true/AllowDownload = false/' /chroot/home/kuberlr/.kuberlr/kuberlr.conf

WORKDIR /tmp

ARG KUBECTL_INFO_LIST

SHELL ["/bin/bash", "-c"]
RUN set -fx; versions=($KUBECTL_VERSION_INFO); \
    for i in "${!versions[@]}"; do \
        echo "The index is $i and the value is ${versions[$i]}"; \
        version=$(echo ${versions[$i]} | cut -d: -f1); \
        kubectl_url="https://dl.k8s.io/release/${version}/bin/linux/${TARGETARCH}/kubectl"; \
        kubectl_target="/tmp/kubectl${version:1}"; \
        echo "Downloading kubectl version ${version} from ${kubectl_url}"; \
        echo "Targeting ${kubectl_target}"; \
        curl -fsSL "$kubectl_url" -o "$kubectl_target"; \
        chmod 0755 "$kubectl_target"; \
    done

RUN set -fx; versions=($KUBECTL_VERSION_INFO); \
    for i in "${!versions[@]}"; do \
        version=$(echo ${versions[$i]} | cut -d: -f1); \
        arm64_sum=$(echo ${versions[$i]} | cut -d: -f2); \
        amd64_sum=$(echo ${versions[$i]} | cut -d: -f3); \
        kubectl_target="/tmp/kubectl${version:1}"; \
        KUBE_SUM_NAME="${TARGETARCH}_sum"; \
        KUBE_SUM=${!KUBE_SUM_NAME}; \
        echo "${KUBE_SUM} ${kubectl_target}" | sha256sum -c -; \
    done

RUN cp /tmp/kubectl* /chroot/usr/bin/

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
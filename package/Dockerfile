ARG BCI_VERSION=15.7
FROM ghcr.io/flavio/kuberlr:v0.6.1 AS kuberlr
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

WORKDIR /tmp
COPY kubectl-versions.txt /tmp/kubectl-versions.txt
# kuberlr get verifies bin hash for us
RUN while read -r version; do \
    /chroot/bin/kuberlr get $version; \
    done < ./kubectl-versions.txt; \
    /chroot/bin/kuberlr bins \
    && cp -a /root/.kuberlr/linux-*/* /chroot/usr/bin/ \
    && /chroot/bin/kuberlr bins

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
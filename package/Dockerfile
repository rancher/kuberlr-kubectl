# syntax=docker/dockerfile:1
ARG BCI_VERSION=16.1
ARG USERNAME=kuberlr
ARG UID=1000
ARG GID=1000

FROM registry.suse.com/bci/bci-busybox:${BCI_VERSION} AS final
FROM registry.suse.com/bci/bci-base:${BCI_VERSION} AS builder

ARG USERNAME
ARG UID
ARG GID
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
    zypper --installroot /chroot -n in bash bash-completion vim

# Pull in kuberlr bin and home dir
RUN zypper ar -f https://rpm.rancher.io/pkgs/prime pkgs && \
    rpm --root /chroot --import https://raw.githubusercontent.com/rancher/rancher/refs/heads/main/rancher-rpm-pkgs.key && \
    zypper --installroot /chroot -n in -r pkgs kuberlr

# The symbolic link target has no /chroot prefix - when inside container.
# The image ENTRYPOINT is /bin/kubectl and /bin is a link to /usr/bin, so kubectl has to be in /usr/bin as well:
# a container that is started with only arguments, as the system-upgrade-controller does for its cordon and drain
# steps, fails to start without it.
RUN ln -s /usr/bin/kuberlr /chroot/usr/bin/kubectl && \
    ln -s /usr/bin/kuberlr /chroot/usr/local/bin/kubectl

# Packages are named kubectl-<major>.<minor>, excluding <patch> version
COPY kubectl-versions.txt /kubectl-versions.txt
RUN while read -r version; do \
        zypper --installroot /chroot -n in -r pkgs kubectl-${version} && \
        ln -sf kubectl-${version} /chroot/usr/bin/kubectl${version}; \
    done < /kubectl-versions.txt

# Cleanup Zypper
RUN zypper --installroot /chroot clean -a && \
    rm -rf /chroot/var/cache/zypp/* /chroot/var/log/zypp/* /chroot/etc/zypp/ \
              /chroot/usr/share/doc /chroot/usr/share/man

# Setup kubrlr and kubectl configs
COPY package/bash.bashrc /chroot/etc/bash.bashrc
RUN chroot /chroot /usr/bin/kuberlr completion bash \
        > /chroot/etc/kuberlr-completion.bash && \
    chroot /chroot /usr/local/bin/kubectl completion bash \
            > /chroot/etc/kubectl-completion.bash

# Setup kuberlr user and perms
RUN groupadd -g "${GID}" "${USERNAME}" && \
    useradd -m -u "${UID}" -g "${GID}" -s /bin/bash "${USERNAME}"
COPY --chown=${UID}:${GID} package/kuberlr.conf /home/${USERNAME}/.kuberlr/kuberlr.conf

FROM scratch
ARG USERNAME
ARG UID
ARG GID

COPY --from=builder /chroot /
COPY --from=builder /etc/passwd /etc/group /etc/shadow /etc/

RUN install -d -o ${UID} -g ${GID} -m 0750 /home/${USERNAME}
COPY --from=builder --chown=${UID}:${GID} /home/${USERNAME} /home/${USERNAME}

USER ${UID}:${GID}
WORKDIR /home/${USERNAME}
ENV HOME=/home/${USERNAME}
ENTRYPOINT ["/bin/kubectl"]
CMD ["help"]

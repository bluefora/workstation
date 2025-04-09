FROM ghcr.io/ublue-os/silverblue-main:latest

COPY build.sh /tmp/build.sh

COPY rootcopy /

COPY --from=ghcr.io/ublue-os/ublue-update:latest /rpms/ublue-update.noarch.rpm /tmp/rpms/
RUN pip install topgrade && rpm-ostree install /tmp/rpms/ublue-update.noarch.rpm

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
    

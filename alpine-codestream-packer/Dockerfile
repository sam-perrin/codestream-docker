FROM samperrin/alpine-codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

# Env setup
ENV PACKER_VERSION=1.7.0 \
    PACKER_OSNAME=linux \
    PACKER_OSARCH=amd64 \
    PACKER_DEST=/usr/local/sbin \
    WIN_PROVISIONER_TAR="packer-provisioner-windows-update_0.11.0_linux_amd64.tar.gz" \
    WIN_PROVISIONER_FILE="packer-provisioner-windows-update"

# Packer path setup
ENV PACKER_ZIPFILE=packer_${PACKER_VERSION}_${PACKER_OSNAME}_${PACKER_OSARCH}.zip

# Install packer in path
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_ZIPFILE} ${PACKER_DEST}/
RUN unzip ${PACKER_DEST}/${PACKER_ZIPFILE} -d ${PACKER_DEST} && \
    rm -rf ${PACKER_DEST}/${PACKER_ZIPFILE}

RUN wget --quiet https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.11.0/${WIN_PROVISIONER_TAR} && \
    tar -xvf ${WIN_PROVISIONER_TAR} ${WIN_PROVISIONER_FILE} && \
    mv ${WIN_PROVISIONER_FILE} ${PACKER_DEST} && \
    rm ${WIN_PROVISIONER_TAR}
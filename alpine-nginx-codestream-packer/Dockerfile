FROM nginx:1.18.0-alpine
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

ARG APK_GLIBC_VERSION=2.32-r0
ARG APK_GLIBC_FILE="glibc-${APK_GLIBC_VERSION}.apk"
ARG APK_GLIBC_BIN_FILE="glibc-bin-${APK_GLIBC_VERSION}.apk"
ARG APK_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${APK_GLIBC_VERSION}"

RUN apk add --no-cache curl wget unzip ca-certificates bash jq git bind-tools

# Get and install glibc for alpine
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget "${APK_GLIBC_BASE_URL}/${APK_GLIBC_FILE}" && \
    wget "${APK_GLIBC_BASE_URL}/${APK_GLIBC_BIN_FILE}" && \
    apk --no-cache add "${APK_GLIBC_FILE}" && \
    apk --no-cache add "${APK_GLIBC_BIN_FILE}" && \
    rm glibc-*

# Install packer in path
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_ZIPFILE} ${PACKER_DEST}/
RUN unzip ${PACKER_DEST}/${PACKER_ZIPFILE} -d ${PACKER_DEST} && \
    rm -rf ${PACKER_DEST}/${PACKER_ZIPFILE}

RUN wget --quiet https://github.com/rgl/packer-provisioner-windows-update/releases/download/v0.11.0/${WIN_PROVISIONER_TAR} && \
    tar -xvf ${WIN_PROVISIONER_TAR} ${WIN_PROVISIONER_FILE} && \
    mv ${WIN_PROVISIONER_FILE} ${PACKER_DEST} && \
    chmod +x ${PACKER_DEST}/${WIN_PROVISIONER_FILE} && \
    rm ${WIN_PROVISIONER_TAR} 
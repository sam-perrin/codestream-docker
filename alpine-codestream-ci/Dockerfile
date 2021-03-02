FROM alpine:3.13.2
LABEL maintainer="sam.perrin@xtravirt.com"

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
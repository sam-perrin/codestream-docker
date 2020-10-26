FROM alpine:3.12

ARG GOVC_VERSION=0.22.1
ARG OVFTOOL_FILENAME=VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle

# Install additional tools
RUN apk add --no-cache curl ca-certificates bash jq python3 && \
    apk add --no-cache --virtual .build-apps wget unzip git coreutils libgcc

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-bin-2.32-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-i18n-2.32-r0.apk
RUN apk add glibc-2.32-r0.apk glibc-bin-2.32-r0.apk glibc-i18n-2.32-r0.apk && \
    /usr/glibc-compat/bin/localedef -i en_GB -f UTF-8 en_GB.UTF-8 && \
    rm -f glibc-2.32-r0.apk glibc-bin-2.32-r0.apk glibc-i18n-2.32-r0.apk

# Install ovftool
RUN wget --quiet https://raw.githubusercontent.com/sam-perrin/codestream-cluster-api/master/files/$OVFTOOL_FILENAME && \
    chmod +x /$OVFTOOL_FILENAME && \
    /bin/sh /$OVFTOOL_FILENAME --console --eulas-agreed --required && \
    rm -f /$OVFTOOL_FILENAME

#Download and Extract GOVC
RUN wget --quiet https://github.com/vmware/govmomi/releases/download/v$GOVC_VERSION/govc_linux_amd64.gz && \
    gunzip -fq govc_linux_amd64.gz && \
    mv govc_linux_amd64 govc && \
    chown root govc && \
    chmod ug+r+x govc && \
    mv govc /usr/local/bin/.

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install clusterctl
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.8/clusterctl-linux-amd64 -o clusterctl && \
    mv clusterctl /usr/bin/clusterctl && \
    chmod +x /usr/bin/clusterctl

RUN apk del .build-apps
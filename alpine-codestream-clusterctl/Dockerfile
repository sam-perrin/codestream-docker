FROM samperrin/alpine-codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

ARG GOVC_VERSION=0.24.0
ARG OVFTOOL_FILENAME=VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle

# ADD $OVFTOOL_FILENAME /tmp/

# Install additional tools
RUN apk add --no-cache python3 && \
    apk add --no-cache --virtual .build-apps coreutils libgcc

# Install ovftool
RUN wget --quiet https://raw.githubusercontent.com/sam-perrin/codestream-docker/master/files/$OVFTOOL_FILENAME && \
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
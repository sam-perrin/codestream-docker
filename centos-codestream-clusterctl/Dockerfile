FROM samperrin/centos-codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

ENV GO_Version 1.14
ENV GOVC_Version v0.22.1
ENV OVFTOOL_FILENAME=VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle

# Install additional tools
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install jq -y && \
    yum install python3 -y

# Install ovftool
# ADD $OVFTOOL_FILENAME /tmp/
# WORKDIR /root
# RUN chmod +x /tmp/$OVFTOOL_FILENAME && \
#     /bin/sh /tmp/$OVFTOOL_FILENAME --console --eulas-agreed --required && \
#     rm -f /tmp/$OVFTOOL_FILENAME
RUN wget --quiet https://raw.githubusercontent.com/sam-perrin/codestream-cluster-api/master/files/$OVFTOOL_FILENAME && \
    chmod +x /$OVFTOOL_FILENAME && \
    /bin/sh /$OVFTOOL_FILENAME --console --eulas-agreed --required && \
    rm -f /$OVFTOOL_FILENAME

# Install GO
RUN wget --quiet https://dl.google.com/go/go$GO_Version.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_Version.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    source ~/.bash_profile

# Download and Extract GOVC
RUN wget --quiet https://github.com/vmware/govmomi/releases/download/$GOVC_Version/govc_linux_amd64.gz && \
    gunzip -fq govc_linux_amd64.gz && \
    mv govc_linux_amd64 govc && \
    chown root govc && \
    chmod ug+r+x govc && \
    mv govc /usr/local/bin/.
    #

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install clusterctl
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.8/clusterctl-linux-amd64 -o clusterctl && \
    mv clusterctl /usr/bin/clusterctl && \
    chmod +x /usr/bin/clusterctl
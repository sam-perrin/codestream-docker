FROM acharbor01.automationcore.xtravirt.com/xtravirt/codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

ENV GO_Version 1.14
ENV GOVC_Version v0.22.1

# Install ovftool
ADD VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle .
RUN chmod +x VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle && \
    ./VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle --console --eulas-agreed --required && \
    rm -rf VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle


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

# Install jq
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install jq -y

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install clusterctl
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.8/clusterctl-linux-amd64 -o clusterctl && \
    mv clusterctl /usr/bin/clusterctl && \
    chmod +x /usr/bin/clusterctl


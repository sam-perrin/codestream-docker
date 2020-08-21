FROM acharbor01.automationcore.xtravirt.com/xtravirt/codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

# Install ovftool
COPY VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle .
RUN chmod +x VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle && \
    ./VMware-ovftool-4.4.0-16360108-lin.x86_64.bundle

# Install Go
RUN apk add --no-cache make go jq

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Govc
RUN go get -u github.com/vmware/govmomi/govc && rm -rf /var/cache/apk/*

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install clusterctl
RUN curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v0.3.8/clusterctl-linux-amd64 -o clusterctl && \
    mv clusterctl /usr/bin/clusterctl && \
    chmod +x /usr/bin/clusterctl


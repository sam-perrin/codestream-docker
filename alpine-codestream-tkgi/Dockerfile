FROM samperrin/alpine-codestream-ci:latest
LABEL maintainer="sam.perrin@xtravirt.com"

ARG TKGI_CLI_FILENAME=tkgi-linux-amd64-1.12.0-build.369
ADD $TKGI_CLI_FILENAME .

# Install additional tools
RUN apk add --no-cache python3 && \
    apk add --no-cache --virtual .build-apps coreutils libgcc

# Install tkgi
#RUN wget https://raw.githubusercontent.com/sam-perrin/codestream-docker/master/files/$TKGI_CLI_FILENAME 
RUN chmod +x /$TKGI_CLI_FILENAME
RUN mv /$TKGI_CLI_FILENAME /usr/bin/tkgi

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

RUN apk del .build-apps
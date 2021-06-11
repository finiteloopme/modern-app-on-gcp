#!/bin/bash

sudo apt update
sudo apot install curl

GO_VERSION=1.16.5
# download go
curl -O https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
sha256sum go${GO_VERSION}.linux-amd64.tar.gz
# install go
tar xvf go${GO_VERSION}.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv go /usr/local
# Configure GO variables
cat <<EOF >> .profile
# GO config
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
EOF
source .profile

mkdir -p $GOPATH

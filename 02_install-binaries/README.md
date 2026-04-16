# Installing kubev

In this lab you will learn how to install kubev.

```bash

# TODO use oras (involves getting throw away credentials from quay)
https://deploy-preview-2093--cranky-newton-4e6ed2.netlify.app/kubermatic-virtualization/main/getting-kubermatic-virtualization/#using-oras

# for now build binaries and send them out
# clone git repo kubermatic-virtualization
# make build
# make all
# make kubev-installer  
# rm bin/kubermatic-virtualization
make kubermatic-virtualization

# copy kubermatic-binaries binary and charts directory (due to multus resource issue) into IDE

# install kubermatic-virtualization into your path
install -m 700 -o root -g root /training/kubermatic-virtualization /usr/local/bin/kubev

# verify
kubev version
```

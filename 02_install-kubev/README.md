
# build

```bash

# TODO use oras 
https://deploy-preview-2093--cranky-newton-4e6ed2.netlify.app/kubermatic-virtualization/main/getting-kubermatic-virtualization/#using-oras
https://kubermatic.slack.com/archives/C07NE68QK7V/p1774940527798819



clone git repo kubermatic-virtualization
make build
make all
make kubev-installer  
rm bin/kubermatic-virtualization
make kubermatic-virtualization

########## TODO do not do this on loki, do this on jumphost

cp -r /Users/hubert/git/kubermatic_kubermatic-virtualization/bin/kubermatic-virtualization /Users/hubert/git/cloudnativetrainings_kubev/bin/

# AT vscode
cp /training/bin/kubermatic-virtualization /usr/local/bin/kubev

kubev version

```

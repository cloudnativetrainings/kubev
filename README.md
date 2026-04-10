
## SSH

```bash

mkdir /training/.secrets/

# drag and drop the sensitive files

mkdir /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev.pub /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev-config /root/.ssh/config
ls -alh /root/.ssh/

# verify
ssh controlplane-node
ssh worker-node
```

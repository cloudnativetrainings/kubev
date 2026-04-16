# Kubermatic Virtualization

In this training you will learn how to install and use Kubermatic Virtualization.

## Training Setup

You should have received sensitive information giving you access to VMs with nested virtualization engaged.

Please ensure you have done the steps as discribed in the `README.md` file you have received.

## Using the IDE

```bash
# visit http://localhost:8080 in your browser

# create the directory /training/.secrets/
mkdir /training/.secrets/

# drag and drop the sensitive files you received into the directory /training/.secrets/

# ensure a comfy way for doing ssh stuff
mkdir /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev.pub /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev-config /root/.ssh/config

# verify
ls -alh /root/.ssh/

# ssh into the vm which will get the controlplane-node
ssh controlplane-node

# ssh into the vm which will get the worker-node
ssh worker-node
```

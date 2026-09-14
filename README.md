# Kubermatic Virtualization

In this training you will learn how to install and use Kubermatic Virtualization.

## Training Setup

You should have received sensitive information giving you access to VMs with nested virtualization enabled.

Please ensure you have done the steps as described in the `README.md` file you have received.

## Using the IDE

Visit http://localhost:8080 in your browser.

```bash
# create the directory /training/.secrets/
mkdir -p /training/.secrets/
```

Drag and drop the sensitive files you received into the directory `/training/.secrets/`.

```bash
# ensure a comfy way for doing ssh stuff
mkdir -p /root/.ssh
```

```bash
# copy the ssh files in the /root/ssh directory
install -m 600 -o root -g root /training/.secrets/gcp-kubev /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev.pub /root/.ssh
install -m 600 -o root -g root /training/.secrets/gcp-kubev-config /root/.ssh/config
```

```bash
# verify
ls -alh /root/.ssh/
```

```bash
# ssh into the vm which will get the controlplane-node
ssh controlplane-node
```

```bash
# ssh into the vm which will get the worker-node
ssh worker-node
```

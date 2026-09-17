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

## Configure gcp

>**NOTE:**
>For terraform and kubeone it is enough having the environment variable called `GOOGLE_CREDENTIALS` set properly. In our case we need access to gcloud via terminal for being able to create infrastructure like DNS entries.

```bash
# activate gcp account
gcloud auth activate-service-account --key-file=/training/.secrets/gcp-service-account.json

# set the gcp project
gcloud config set project $GCP_PROJECT --quiet

# set the compute region and zone
gcloud config set compute/region europe-west3
gcloud config set compute/zone europe-west3-a

# verify your settings
gcloud config list
```

## Verify your environment

```bash
# ensure all environment variables get set in your current bash
source /root/.trainingrc

# verify

TODO

make verify
```

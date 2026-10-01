# Prerequisites

In this lab you will learn how to install and use Kubermatic Virtualization.

## Training Setup

You should have received sensitive information giving you access to VMs with nested virtualization enabled.

Please ensure you have done the steps as described in the `README.md` file you have received.

## Using the IDE

Visit http://localhost:8080 in your browser.

```bash
# create the directory /training/.secrets/
mkdir -p /training/.secrets/
```

Drag and drop the sensitive files you received into the directory `/training/.secrets/`:

- environment.sh
- gcp-kubev
- gcp-kubev-config
- gcp-kubev.pub
- gcp-service-account.json
- README.md

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

## Set important environment variables

> **IMPORTANT:**
> These variables will get referenced during the following labs. Make sure to set them before continuing.

```bash
# make the shell script executable
chmod 0700 /training/.secrets/environment.sh

# persist the environment variables into the file /root/.trainingrc
/training/.secrets/environment.sh

# ensure changes are applied in your current bash
source /root/.trainingrc

# verify
echo $GCP_PROJECT
echo $TRAINEE_NAME
echo $TRAINEE_EMAIL
echo $JUMPHOST_INT_IP
echo $JUMPHOST_EXT_IP
echo $CONTROLPLANE_INT_IP
echo $CONTROLPLANE_EXT_IP
echo $WORKER_INT_IP
echo $WORKER_EXT_IP
```

## Configure gcp

>**NOTE:**
>For terraform and kubeone it is enough having the environment variable called `GOOGLE_CREDENTIALS` set properly. In our case we need access to gcloud via terminal for being able to create infrastructure like DNS entries.

<!-- TODO do I really need GOOGLE_CREDENTIALS???-->

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
make verify
```

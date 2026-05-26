# Installing kubermatic-virtualization to your environment

In this lab you will learn how to install kubermatic-virtualization binary to your environment. This will be used to create a k8s cluster and install all the needed components, in the right versions, into it.

See [documentation](https://docs.kubermatic.com/kubermatic-virtualization/v1.1.0/getting-kubermatic-virtualization/) for details.

```bash
# download the kubermatic-ee-downloader
curl -sfL https://raw.githubusercontent.com/kubermatic/kubermatic-ee-downloader/main/install.sh | sh
```

After downloading and installing the kubermatic-ee-downloader you have to provide credentials for being able to install kubermatic-virtualization-installer. For the workshop you will receive a temporary license. Please contact us if you want to get a permanent license.

```bash
# set the quay username
export KUBEV_USERNAME=<FILL-IN-QUAY-USERNAME>

# set the quay password
export KUBEV_PASSWORD=<FILL-IN-QUAY-PASSWORD>

# list all installable products
./kubermatic-ee-downloader list

# get the kubermatic-virtualization-installer
./kubermatic-ee-downloader get kubermatic-virtualization --username $KUBEV_USERNAME --password $KUBEV_PASSWORD
```

Add some convienience into your environment.

```bash
# install kubermatic-virtualization into your path
install -m 700 -o root -g root /training/kubermatic-virtualization /usr/local/bin/kubev

# verify
kubev version
```


# Create kubermatic-virtualization cluster

In this lab you will learn how to make use of the kubermatic-virtualization-installer to spawn a k8s cluster and install the needed components, in their proper versions, into the k8s cluster.

## Preparations

Fill in the internal IP addresses provided in the file `/training/.secrets/README.md` for the controlplane-node and the worker-node in the kubev configuration file `/training/cluster.yaml`.

## Run the installer

The installer will set up a Kubernetes cluster via [kubeone](https://github.com/kubermatic/kubeone) and install the kubev components.

```bash
# trigger the installation
kubev apply -f /training/cluster.yaml -yv
```

```bash
# you can take a look at the logs of the installation process via
tail -f /tmp/kubermatic-virtualization.log
```

```bash
# verify if cluster is fine
kubectl --kubeconfig /training/kubev-cluster-kubeconfig get nodes
```

```bash
# move the kubeconfig to `/root/.kube/config`
mv /training/kubev-cluster-kubeconfig /root/.kube/config
```

```bash
# verify the installed components are all in running state
kubectl get pods --all-namespaces
```

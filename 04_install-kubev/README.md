
# Install KubeV

In this lab you will learn how to install KubeV.

## Preparations

Fill in the internal ip addresses provided in the file `/training/.secrets/README.md` for the control-plane-node and the worker node in the kubev configuration file `/training/cluster.yaml`.

## Run the installer

The installer will setup a Kubernetes Cluster via [kubeone](https://github.com/kubermatic/kubeone) and install the kubev components.

```bash
# trigger the installation
kubev apply -f /training/cluster.yaml -y

# you can take a look at the logs of the installation process via
tail -f /tmp/kubermatic-virtualization.log

# verify if cluster is fine
kubectl --kubeconfig /training/kubev-cluster-kubeconfig get nodes

# copy the kubeconfig created via kubeone to the location the $KUBECONFIG is set, for convience only
mv /training/kubev-cluster-kubeconfig /training/.secrets/kubev-cluster-kubeconfig

# verify the installed components are all in running state
kubectl get pods --all-namespaces

# [OPTIONAL] if the kube-multus pods are not in state running you may have to increase the memory
# if so, apply the multus-cni helm chart like khis
# NOTE: this issue already got addressed via https://github.com/kubermatic/kubermatic-virtualization/pull/146
helm upgrade --install --rollback-on-failure --debug \
  --namespace kube-system multus-cni \
  /training/charts/multus-cni/ 
```

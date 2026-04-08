
## debug

```bash

# importer runs
# virt-launcher runs

# chech vm objects
kubectl logs -n kubevirt deployment/virt-controller

# check vmi objects
kubectl logs -n kubevirt daemonset/virt-handler

# check datavloume
kubectl get datavolume
kubectl describe datavolume root-volume

# check pvc
kubectl get pvc
kubectl describe pvc root-volume




kubectl apply -f 05_create-vm/service.yaml
kubectl get svc

kubectl run netshoot --image=nicolaka/netshoot --restart=Never --rm -it -- bash

kubectl run virtctl-pod --image=ubuntu --restart=Never --rm -it -- bash
  apt-get update && apt-get install -y curl
  curl -LO https://github.com/kubevirt/kubevirt/releases/download/v1.5.3/virtctl-v1.5.3-linux-amd64
  install -o root -g root -m 0755 virtctl-v1.5.3-linux-amd64 /usr/local/bin/virtctl
  apt-get update && apt-get install -y openssh-client
  virtctl ssh ubuntu@my-vm-with-http-data-volume


```

## debug

```bash











kubectl virt ssh my-vm-with-http-data-volume

# install virtctl version 1.5.3
curl -LO https://github.com/kubevirt/kubevirt/releases/download/v1.5.3/virtctl-v1.5.3-linux-amd64
install -o root -g root -m 0755 /training/virtctl-v1.5.3-linux-amd64 /usr/local/bin/virtctl
virtctl version


kubectl get vmi -o wide


#########

virtctl ssh vmi/my-vm-with-http-data-volume

 virtctl ssh ubuntu@my-vm-with-http-data-volume --namespace default

  virtctl port-forward vmi/my-vm-with-http-data-volume 22:22 &
  ssh -o StrictHostKeyChecking=no ubuntu@localhost -p 22


# in cluster network
  kubectl run virtctl-pod --image=ubuntu --restart=Never --rm -it -- bash
  apt-get update && apt-get install -y curl
  curl -LO https://github.com/kubevirt/kubevirt/releases/download/v1.5.3/virtctl-v1.5.3-linux-amd64
  install -o root -g root -m 0755 virtctl-v1.5.3-linux-amd64 /usr/local/bin/virtctl
  apt-get update && apt-get install -y openssh-client
  virtctl ssh ubuntu@my-vm-with-http-data-volume

```

```bash
# krew virt does not work due to ancient kubevirt version

https://kubevirt.io/user-guide/user_workloads/virtctl_client_tool/

# install krew
kubectl krew list
kubectl krew install virt
kubectl krew list
kubectl virt help

```

```log
kubectl virt ssh my-vm-with-http-data-volume
You are using a client virtctl version that is different from the KubeVirt version running in the cluster
Client Version: v1.8.0
Server Version: v1.5.3

target must contain type and name separated by '/'
```

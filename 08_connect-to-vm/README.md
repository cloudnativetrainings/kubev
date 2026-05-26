
# Connect to the VM

In this lab you will learn how to connect to the VM.

## Via virtctl

```bash
# connect via ssh
virtctl ssh root@my-vm --identity-file /root/.ssh/gcp-kubev

# printout the hostname of the vm
hostname

# exit the vm
# note, if that does not work you got a hint how to disconnect 
exit

# connect via console
# note, only password auth is supported here, get the password from the file /training/my-vm.yaml
virtctl console my-vm

# printout the hostname of the vm
hostname

# exit the vm
# note, if that does not work you got a hint how to disconnect 
exit
```

## Via Kubernetes Service

### Create the Service

```bash
# inspect the service
code /training/my-vm-service.yaml

# apply the service
kubectl apply -f /training/my-vm-service.yaml

# check the endpoints
kubectl get endpoints
```

### Connect via the NodePort

```bash

# get the internal ip of the worker node
kubectl get nodes -o wide

# connect to the vm via the nodeport 30022 on the worker node
ssh -i /root/.ssh/gcp-kubev root@<FILL-IN-INTERNAL-IP-OF-WORKER-NODE> -p 30022

# printout the hostname of the vm
hostname

# exit the vm
# note, if that does not work you got a hint how to disconnect 
exit
```

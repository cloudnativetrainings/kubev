
# Create a VM

In this lab you will learn how to create a VM.

## User Management for the VM

```bash

# inspect the file /training/my-vm.yaml
code /training/my-vm.yaml

# add the content of /training/user-data.yaml into /training/my-vm.yaml in the volume called cloudinit
```

## Start the VM creation process

```bash
# apply the vm
kubectl apply -f /training/my-vm.yaml

# watch the vm being created
watch -n 1 kubectl get pods,vm,vmi,pv,pvc
```

> Note: several pods pop up (cdi-upload-tmp-pvc, source, virtlauncher pods) which are creating the VM instance.

## Managing running VMs

```bash
# getting the logs of the VM
kubectl logs virt-launcher-... -c guest-console-log

# stop the vm
kubectl delete vmi my-vm

# start the vm
virtctl start my-vm  
```

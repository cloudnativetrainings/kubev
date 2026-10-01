
# Connect to the VM

In this lab you will learn how to connect to the VM.

## Via console

<!-- TODO exit the vm command -->

```bash
# connect via console
# note, only password auth is supported here, get the password from the file /training/my-vm.yaml
virtctl console my-vm
```

```bash
# printout the hostname of the vm
hostname
```

```bash
# exit the vm
# note, if that does not work, you got a hint on how to disconnect
exit
```

## Via Kubernetes Service

### Create the Service

```bash
# inspect the service
code /training/my-vm-service.yaml
```

```bash
# apply the service
kubectl apply -f /training/my-vm-service.yaml
```

```bash
# check the endpoints
kubectl get endpoints
```

### Connect via the NodePort

```bash
# get the internal ip of the worker node
kubectl get nodes -o wide
```

```bash
# connect to the vm via the nodeport 30022 on the worker node
ssh -i /root/.ssh/gcp-kubev root@<FILL-IN-INTERNAL-IP-OF-WORKER-NODE> -p 30022
```

<!-- TODO store ip of cp and worker node in env in .trainingrc -->

```bash
# printout the hostname of the vm
hostname
```

```bash
# exit the vm
# note, if that does not work, you got a hint on how to disconnect
exit
```

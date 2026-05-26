
# does not work anymore via gcp

## Via kubectl port-forwarding

```bash
# port-forward the virt-launcher pod
kubectl port-forward pod/virt-launcher-my-vm-... 2222:22

# TODO does not work anymore
# ssh to localhost on port 2222
ssh -i /root/.ssh/gcp-kubev.pub root@localhost -p 2222

# printout the hostname of the vm
hostname

# exit the vm
# note, if that does not work you got a hint how to disconnect 
exit
```

### Connect via LoadBalancer

```bash
# get the ip of the VM
kubectl get svc

# TODO does not work, seems like a firewall issue or it even do not work at all due to GCP networking

# connect to the vm via the loadbalancer
ssh -i /root/.ssh/gcp-kubev root@<EXTERNAL-IP-OF-VM-SERVICE>

# printout the hostname of the vm
hostname

# exit the vm
# note, if that does not work you got a hint how to disconnect 
exit
```

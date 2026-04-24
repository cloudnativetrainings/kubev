
# Using MetalLB

Before we expose VMs to external IP addresses lets try doing this via plain old Pods.

```bash
# verify no ip exists for the training-application
kubectl get ips | grep training-application 

# verify ipaddresspool was created and the annotation of the service matches the name
kubectl -n metallb-system get ipaddresspools.metallb.io

# deploy the planing application
kubectl apply -f /training/training-application.yaml

# verify the pod is running and take a look at the ip of the pod
kubectl get pods -o wide

# verify the endpoint for the service got created and it directs to the ip of the pod
kubectl get endpoints

# verify the ip for the training-application now exists
kubectl get ips | grep training-application 

# verify the training-application got an external ip address out of the pool we configured in /training/cluster.yaml
kubectl get svc

# curl the external ip
curl http://<EXTERNAL-IP>

# TODO does not work, seems like a firewall issue or it even do not work at all due to GCP networking

# delete the training-application again
kubectl delete -f /training/training-application.yaml
```

## Debugging metallb

Due to this [issue](https://github.com/kubermatic/kubermatic-virtualization/issues/149) it can happen the ipaddresspool did not get created properly. You may have to create it manually.

```bash

# TODO soeren...
kubectl get l2advertisements -A
kubectl get bgpadvertisements -A

# TODO is this still needed, seems to work now

# verify the ipaddresspool got created
kubectl get ipaddresspools.metallb.io -A 

# if it was not created apply it via
kubectl apply -f /training/metallb.yaml

# debug the metallb-controller
kubectl -n metallb-system logs deployments/metallb-controller | grep training
```

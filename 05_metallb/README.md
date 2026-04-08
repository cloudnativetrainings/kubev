
## fix metallb

```bash
kubectl get ipaddresspools.metallb.io -A 

kubectl apply -f /training/metallb.yaml

kubectl -n metallb-system get ipaddresspools



```

## try with pods

```bash

kubectl get ips | grep training-application 

kubectl apply -f /training/training-application.yaml

# check ips
kubectl get pods -o wide
kubectl get endpoints
kubectl get ips | grep training-application 

kubectl get svc

curl http://<EXTERNAL-IP>
# or browser

kubectl -n metallb-system logs deployments/metallb-controller | grep training

# del
kubectl delete -f /training/training-application.yaml

```


## import image

```bash
# reset vm
kubectl delete -f /training/ubuntu-image-datavolume.yaml
kubectl delete pv,pvc --all
watch -n 1 kubectl get pods,vm,vmi,pv,pvc

# first install the ubuntu datavolume, then vm

kubectl apply -f /training/ubuntu-image-datavolume.yaml
watch -n 1 kubectl get pods,datavolume,pv,pvc
# note the importer pods
```

## create vm

```bash
# restart
kubectl delete -f /training/my-vm.yaml
watch -n 1 kubectl get pods,vm,vmi,pv,pvc

# install
kubectl apply -f /training/my-vm.yaml
watch -n 1 kubectl get pods,vm,vmi,pv,pvc
# note 
#   uploadtmppvc pod, 
#   source pod, 
#   virtlauncher pod
# TODO what are those doing???
```

## logs of vm

```bash

kubectl get pod virt-launcher-... -o jsonpath='{.spec.containers[*].name}'
kubectl logs virt-launcher-my-vm-xqsmx -c guest-console-log
```

## restart vm

```bash
# VM neu starten:
  kubectl delete vmi my-ubuntu-vm
  # startet automatisch neu wegen RerunOnFailure


virtctl start my-ubuntu-vm  
```

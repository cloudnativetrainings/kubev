
```bash

# kubevirt-manager
helm upgrade --install kubevirt-manager /training/charts/kubevirt-manager/ -n kubevirt
kubectl port-forward -n kubevirt svc/kubevirt-manager 8080:8080

# our visualization
# TODO wait until it is more stable
https://github.com/kubermatic/kubermatic-virtualization/tree/main/pkg/dashboard
```


```bash

# TODO
# kubevirt binaries and charts
# TODO logs /tmp/kubermatic-virtualization.log
# TODO on nodes - apt upgrade, apt update
# TODO bake bin and charts into container???

install -m 700 -o root -g root /training/kubermatic-virtualization /usr/local/bin/kubev

# fix cluster.yaml

kubev apply -f /training/cluster.yaml --verbose -y

kubectl --kubeconfig /training/kubev-cluster-kubeconfig get nodes
mv /training/kubev-cluster-kubeconfig /training/.secrets/kubev-cluster-kubeconfig

# multus resource issue
cp -r /Users/hubert/git/kubermatic_kubermatic-virtualization/charts/ /Users/hubert/git/cloudnativetrainings_kubev/charts/
helm upgrade --install --rollback-on-failure --debug \
  --namespace kube-system multus-cni \
  /training/charts/multus-cni/ 


kubectl get pods --all-namespaces
```

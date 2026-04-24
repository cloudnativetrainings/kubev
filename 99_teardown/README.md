
# Teardown

With the following commands you will remove stuff and you can start from scratch again.

```bash
# delete all created vms
kubectl delete vm --all --all-namespaces

# teardown worker node
ssh controlplane-node 'bash -s' < /training/99_teardown/teardown.sh

# teardown worker node
ssh worker-node 'bash -s' < /training/99_teardown/teardown.sh

# cleanup in IDE
rm -f /training/.secrets/*-kubeconfig
rm -f /training/*-kubeconfig
rm -f /training/*linux-amd64
```

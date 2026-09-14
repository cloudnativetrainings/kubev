
# Teardown

With the following commands you will remove stuff and you can start from scratch again.

```bash
# delete all created vms
kubectl delete vm --all --all-namespaces
```

```bash
# teardown worker node
ssh worker-node 'bash -s' < /training/99_teardown/teardown.sh
```

```bash
# teardown control-plane node
ssh controlplane-node 'bash -s' < /training/99_teardown/teardown.sh
```

```bash
# cleanup in IDE
rm -f /training/.secrets/*-kubeconfig
```

```bash
# cleanup in IDE
rm -f /training/*-kubeconfig
```

```bash


kubectl delete vm --all --all-namespaces
ssh controlplane-node 'bash -s' < teardown.sh
ssh worker-node 'bash -s' < teardown.sh

rm -f .secrets/*-kubeconfig
rm -f *-kubeconfig
rm -f *linux-amd64

```

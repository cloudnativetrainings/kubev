```bash


kubectl delete vm --all --all-namespaces
ssh loki 'bash -s' < teardown.sh
ssh thor 'bash -s' < teardown.sh

rm -f .secrets/*-kubeconfig
rm -f *-kubeconfig
rm -f *linux-amd64

```

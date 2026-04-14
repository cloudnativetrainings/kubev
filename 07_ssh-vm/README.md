
# connect to vm

## run virtctl

```bash

virtctl help
# TODO ssh-keygen -f '/root/.ssh/known_hosts' -R '[localhost]:2222'
virtctl ssh root@my-ubuntu-vm --identity-file /root/.ssh/gcp-kubev
hostname

# PASSWORD only as it looks
virtctl console my-ubuntu-vm
# TODO erst machbar sobald ein passwort gesetzt wurde
```

## via kubectl

```bash

# TODO does not work anymore

kubectl port-forward pod/virt-launcher-my-vm-xqsmx 2222:22

# remove from known hosts
ssh-keygen -f '/root/.ssh/known_hosts' -R '[localhost]:2222'
ssh -i /root/.ssh/gcp-kubev.pub root@localhost -p 2222
hostname
```

```md
❯ was bedeutet die liste die mir von ip route ausgegeben wurde

⏺ Zeig mir die Ausgabe, dann kann ich sie konkret erklären.

❯ 10.0.2.0/24 dev k6t-eth0 proto kernel scope link src 10.0.2.1
192.168.100.0/24 dev eth0 proto kernel scope link src 192.168.100.89

⏺ 10.0.2.0/24 dev k6t-eth0 proto kernel scope link src 10.0.2.1
  - k6t-eth0 — KubeVirt Bridge Interface (masquerade NAT). Darüber kommuniziert der Pod mit der VM.
  - 10.0.2.1 — IP des compute Containers (Gateway für die VM)
  - Die VM selbst hat 10.0.2.2 (KubeVirt-Standard für masquerade)

  192.168.100.0/24 dev eth0 proto kernel scope link src 192.168.100.89
  - eth0 — das normale Pod-Netzwerk Interface
  - 192.168.100.89 — IP des virt-launcher Pods im Cluster-Netzwerk

  Also: Die VM ist erreichbar unter 10.0.2.2:
  ssh ubuntu@10.0.2.2 -i /path/to/pubkey
```

## via nodeport service

# TODO my-vm fix naming

```bash

kubectl apply -f /training/my-vm-service.yaml
kubectl get endpoints
kubectl get nodes -o wide
ssh -i /root/.ssh/gcp-kubev root@10.156.0.2 -p 30022
hostname

# remove from known_hosts
ssh-keygen -f '/root/.ssh/known_hosts' -R '[172.25.0.77]:30022'
```

### via loadbalancer service created via metallb

```bash

# TODO service had LB type

sed -i 's/NodePort/LoadBalancer/' my-vm-service.yaml
kubectl apply -f my-vm-service.yaml

kubectl get svc

ssh -i /root/.ssh/gcp-kubev root@192.168.99.100 
hostname

```

```bash
# only debugging stuff

kubectl run netshoot --rm -it --image nicolaka/netshoot -- bash
  curl http://192.168.100.240
  ssh ubuntu@192.168.100.240
  ping 192.168.100.240


kubectl -n metallb-system logs daemonsets/metallb-speaker
# auf worker node
arp -n | grep 192.168.100.240
ip addr show | grep 192.168.100.240


# ssh worker node
ip route get 192.168.100.240

# install arping on worker
arping -I ovn0 192.168.100.240


```

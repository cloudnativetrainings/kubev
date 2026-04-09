
ssh files
bin files
cluster.yaml
charts dir

create .secrets dir
copy files into container
or mount /root/.ssh/training-kubev to /training/.secrets

# TODO logs /tmp/kubermatic-virtualization.log

```bash

# TODO on nodes - apt upgrade, apt update

# fix cluster.yaml ips
kubev apply -f /training/cluster.yaml --verbose -y

# debug
⏺ # systemd journal (empfohlen)                                                                     
  journalctl -u kubelet -f                                                                            
                                                                                                      
  # oder rückwirkend                                                                                  
  journalctl -u kubelet --since "1 hour ago"                                                          
                                                                                                      
  # kubeadm init/reset schreibt direkt auf stdout/stderr                                              
  # falls du es mit dem Installer gestartet hast:
  journalctl -u kubermatic-virtualization -f                                                          
                                                                                                      
  Die eigentlichen Kubernetes-Komponenten (API-Server, etcd, scheduler) laufen als Static Pods — deren
   Logs:                                                                                              
                                                                                                      
  # API-Server                                                                                      
  kubectl logs -n kube-system kube-apiserver-$(hostname)
                                                                                                      
  # oder direkt via crictl (wenn kubectl nicht geht)                                                  
  crictl logs $(crictl ps -a | grep apiserver | awk '{print $1}')               

# kubeadm failure
nc -zv 34.179.224.188 6443 
 systemctl status kubelet 

kubectl --kubeconfig kubev-cluster-kubeconfig get nodes
cp kubev-cluster-kubeconfig /training/.secrets/kubev-cluster-kubeconfig

# multus resource issue
cp -r /Users/hubert/git/kubermatic_kubermatic-virtualization/charts/ /Users/hubert/git/cloudnativetrainings_kubev/charts/
helm upgrade --install --rollback-on-failure --debug \
  --namespace kube-system multus-cni \
  /training/charts/multus-cni/ 


kubectl get pods --all-namespaces
```

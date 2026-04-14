# MetalLB in diesem Projekt

## Konfiguration

MetalLB läuft im **Layer-2-Modus** (ARP). IP-Range aus `cluster.yaml`:

```
192.168.100.240 – 192.168.100.250
```

Wenn ein `LoadBalancer` Service erstellt wird, vergibt MetalLB eine IP aus diesem Range und antwortet auf ARP-Anfragen im Netzwerk für diese IP.

## Netzwerk-Topologie

```
Dein Laptop
    │
    ├── 192.168.99.0/24  → SSH zu den Nodes (controlplane/worker)
    │
    └── 192.168.100.0/24 → Cluster-Netzwerk (Pods, MetalLB IPs)
```

## Erreichbarkeit von außen

| Von wo | Erreichbar? | Grund |
|--------|-------------|-------|
| Training-Container (`make run`) | Nein | Keine Route ins `192.168.100.0/24`-Netz |
| Laptop direkt | Nur mit Route | Braucht Route zu `192.168.100.0/24` über einen Node |
| Von einem Node (`192.168.99.9` / `.27`) | Ja | Nodes sind im selben Netzwerk |

## Nützliche Befehle

```bash
# Welche IP hat ein Service bekommen:
kubectl get svc my-vm-ssh
# EXTERNAL-IP zeigt die MetalLB-IP

# Von einem Node aus testen:
ssh -i /root/.ssh/gcp-kubev.pub root@192.168.99.27
curl http://192.168.100.240
```

## SSH-Zugriff auf VM via LoadBalancer Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-vm-ssh
spec:
  type: LoadBalancer
  selector:
    kubevirt.io/domain: my-vm
  ports:
    - port: 22
      targetPort: 22
```

```bash
# IP ermitteln
kubectl get svc my-vm-ssh

# SSH von einem Node aus
ssh -i /root/.ssh/gcp-kubev.pub ubuntu@192.168.100.24x
```

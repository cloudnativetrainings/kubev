
# apply

```bash

cd /root/kubev/

kubev install

```

## Network Configuration

create network @ udm https://unifi.ui.com/
kein DNS Server einstweilen

- Network CIDR 192.168.100.0/24
- DNS Server 8.8.8.8
- Gateway IP 192.168.100.1

## LoadBalancer Configuration

- LoadBalancer IP range 192.168.100.240-192.168.100.250

## Node Configuration

- Total Node Count 1
- ControlPlane Count 1
- API Endpoint -

### Individual Nodes

ssh-keygen

- Address 192.168.99.27
- Username root
- SSH-Key Path /root/.ssh/id_ed25519

## Default CSI Driver

true

# debug

/tmp/kubermatic-virtualization.log

⏺ CoreDNS is running but can't reach 8.8.8.8:53 upstream. The pod on 10.156.0.25 is timing out on
  external DNS.

  Likely cause: GCP firewall blocking outbound UDP/53 from the pod network, or pod-to-internet NAT
  (masquerade) isn't set up for the pod CIDR 10.156.0.0/16.

  Check if masquerade is configured on the node:

  ssh root@10.156.0.4 -i .secrets/ssh-private-key 'iptables -t nat -L POSTROUTING -n -v | grep -i
  masq'

  Also worth noting: your networkCIDR: 10.156.0.0/16 in cluster.yaml overlaps with the GCP internal
  node IPs (10.156.0.4, 10.156.0.3). That could cause routing conflicts.

  But if internal DNS resolution works (pod-to-pod, service names), this warning may not block the lab
   — CoreDNS will still resolve in-cluster names. Is anything actually failing because of this?

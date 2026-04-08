# MetalLB Controller vs Speaker

## MetalLB Controller (1x, Deployment)
- Vergibt IPs aus dem Pool an `LoadBalancer` Services
- Schreibt die `EXTERNAL-IP` in den Service
- Kennt alle IPAddressPools und L2Advertisements

## MetalLB Speaker (1x pro Node, DaemonSet)
- Macht die IP im Netzwerk bekannt
- Im L2-Modus: antwortet auf ARP-Anfragen für die vergebene IP
- Nur der Speaker auf dem Node, der den Service-Endpoint hostet, übernimmt die IP (Leader Election)

## Zusammenspiel

```
Controller  →  "Service bekommt 192.168.100.240"
Speaker     →  antwortet auf ARP: "192.168.100.240 bin ich (Node 192.168.99.27)"
Traffic     →  kommt am Node an → wird per kube-proxy an den Pod weitergeleitet
```

## Wichtig

Wenn der Endpoint leer ist, macht der Speaker die IP gar nicht per ARP bekannt — deshalb `Destination Host Unreachable`.

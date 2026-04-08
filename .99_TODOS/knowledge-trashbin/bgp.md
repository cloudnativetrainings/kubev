# BGP — Border Gateway Protocol

**BGP** ist das Routing-Protokoll des Internets. Es tauscht zwischen autonomen Systemen (AS) Erreichbarkeitsinformationen aus — also welche IP-Präfixe über welchen Weg erreichbar sind.

## Grundprinzip

Jedes AS hat eine eindeutige Nummer (ASN). BGP-Router (Peers) bauen TCP-Verbindungen (Port 179) zueinander auf und tauschen Routen aus.

```
AS 65001 (Firma A)  ←── BGP Session ───→  AS 65002 (Firma B)
   10.0.0.0/8                                  172.16.0.0/12
```

## iBGP vs eBGP

| Typ | Beschreibung |
|-----|-------------|
| **eBGP** | Zwischen verschiedenen AS (External BGP) |
| **iBGP** | Innerhalb desselben AS (Internal BGP) |

## Einsatz in Kubernetes / MetalLB

MetalLB kann BGP nutzen, um LoadBalancer-IPs an den physischen Router anzukündigen:

- MetalLB spricht eBGP mit dem Top-of-Rack-Switch
- Sobald ein Service eine externe IP bekommt, wird diese Route per BGP advertised
- Der Router weiß dann, über welchen Node die IP erreichbar ist

```
Client → Router → (BGP-Route) → Node mit Pod
```

## Relevanz im Training

In `cluster.yaml` ist ein MetalLB IP-Range konfiguriert (`192.168.100.240–250`). MetalLB kann dort im L2-Modus (ARP) oder BGP-Modus betrieben werden. Im Training wird L2 verwendet — BGP wäre die Alternative für produktionsnahe Setups mit echtem Router-Peering.

## Wichtige Begriffe

| Begriff | Bedeutung |
|---------|-----------|
| **ASN** | Autonomous System Number (z.B. 65000–65535 für privat) |
| **Peer** | BGP-Nachbar, mit dem Routen ausgetauscht werden |
| **Prefix/Route** | IP-Netz das advertised wird (z.B. 10.0.0.0/24) |
| **next-hop** | IP-Adresse des nächsten Routers auf dem Weg zum Ziel |

# Bridge Mode — Netzwerk-Details: Router, NICs, IP-Vergabe

## Kurzantwort

Es gibt **zwei grundlegend verschiedene Szenarien** für bridge mode — je nachdem ob die Bridge an das Pod-Netzwerk oder an ein physisches Interface gebunden ist.

---

## Szenario 1: Bridge auf dem Pod-Netzwerk (Standard)

```yaml
networks:
  - name: default
    pod: {}
interfaces:
  - name: default
    bridge: {}
```

- Die VM wird über eine Linux Bridge an das **Pod-CIDR-Netzwerk** angebunden (z.B. 10.244.0.0/16).
- Die VM **übernimmt die IP und MAC des Pods** — aus Netzwerksicht ist die VM der Pod.
- **Kein zusätzliches NIC** am Worker Node nötig.
- **Router muss nichts konfiguriert werden** — das Routing läuft wie bei normalen Pods.
- Die VM bekommt **keine IP vom Router-DHCP** — die IP kommt vom CNI-IPAM (z.B. Flannel, Calico).

```
VM (Pod-IP, Pod-MAC) ← Linux Bridge ← veth-pair ← Node ← CNI-Netzwerk
```

> Hinweis: Dieser Modus ist in neueren KubeVirt-Versionen **deprecated** zugunsten von masquerade.

---

## Szenario 2: Bridge auf einem physischen Interface (via Multus)

Hier wird ein zusätzliches Netzwerk-Interface der VM direkt an ein physisches Netzwerk des Worker Nodes angebunden.

### Architektur

```
VM-NIC ← Linux Bridge (br0) ← eth1 (physisches NIC) ← Switch ← Router
```

### Braucht der Worker Node mehrere Ethernet-Interfaces?

**Ja, typischerweise.** Das physische Interface (`eth1`, `ens4`, etc.) wird in die Linux Bridge "enslaved":

```bash
ip link add br0 type bridge
ip link set eth1 master br0
ip link set br0 up
```

- `eth1` verliert dabei seine eigene IP — die Bridge übernimmt.
- Das bestehende Cluster-Interface (`eth0`) bleibt für Kubernetes-Traffic (API-Server, kubelet, CNI).
- Alternativ: **VLANs** auf einem Interface — dann reicht ein physisches NIC, aber der Switch muss VLAN-Trunking unterstützen.

### Bekommt die VM eine IP vom Router?

**Ja.** Die VM erscheint im physischen Netzwerk mit ihrer eigenen virtuellen MAC-Adresse:

- Der DHCP-Server des Routers sieht die MAC der VM und vergibt eine IP.
- Die VM ist ein vollwertiger Netzwerkteilnehmer — der Router sieht sie wie ein weiteres Gerät.
- Ping, SSH etc. direkt zur VM-IP möglich, ohne Kubernetes Service.

```
Router (DHCP) → vergibt 192.168.1.50 an VM-MAC → VM ist direkt erreichbar
```

### Was muss am Router/Switch konfiguriert werden?

| Thema | Muss konfiguriert werden? | Warum |
|-------|--------------------------|-------|
| DHCP-Bereich | nein (wenn VM in vorhandenem Subnetz) | Router vergibt einfach eine IP aus dem Pool |
| Routing | nein (gleiches Subnetz) / ja (eigenes VM-Subnetz) | Bei eigenem VM-CIDR braucht der Router eine Route |
| Promiscuous Mode (NIC) | manchmal | Das physische NIC muss Traffic für fremde MACs durchlassen |
| Switch: mehrere MACs pro Port | manchmal | Managed Switches (z.B. Cisco, VMware vSwitch) blockieren per Default mehrere MACs pro Port → "MAC flooding protection" deaktivieren oder Port-Security anpassen |

### Promiscuous Mode

Das physische NIC des Worker Nodes muss Traffic für die **VM-MAC** akzeptieren (die es selbst nicht besitzt):

```bash
ip link set eth1 promisc on
```

Bei Bare-Metal-Setups meist kein Problem. Bei VMs-in-VMs (nested) oder managed Switches kann das geblockt werden.

---

## Zusammenfassung

| Frage | Pod-Netzwerk Bridge | Physisches Bridge (Multus) |
|-------|--------------------|-----------------------------|
| Zusätzliches NIC am Node? | nein | ja (oder VLAN) |
| IP vom Router-DHCP? | nein (IP vom CNI) | ja |
| Router-Konfiguration nötig? | nein | nur bei eigenem Subnetz |
| Switch-Konfiguration nötig? | nein | ggf. MAC/Promiscuous |
| VM direkt erreichbar? | nein (via Service) | ja |
| Anwendungsfall | Standard-VM | VM als vollwertiger Netzwerkteilnehmer |

---

## Typisches Setup in diesem Lab (cluster.yaml)

Das Lab nutzt MetalLB im Bereich `192.168.100.240–250`. Für VMs mit physischer Bridge-Anbindung würde man:

1. `eth1` (zweites NIC) auf Worker Node 192.168.99.27 in Bridge legen.
2. Multus NetworkAttachmentDefinition erstellen.
3. VM-Spec um zweites Interface erweitern.
4. DHCP-Server (Router) im Zielnetz läuft, vergibt IP an VM-MAC.

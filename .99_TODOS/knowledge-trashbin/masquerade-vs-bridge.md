# Masquerade vs Bridge — VM Networking in KubeVirt

KubeVirt bietet verschiedene Netzwerk-Binding-Modi für VMs. Die zwei häufigsten sind **masquerade** und **bridge**.

---

## Masquerade

```yaml
interfaces:
  - name: default
    masquerade: {}
```

- Die VM bekommt eine **interne private IP** (z.B. `10.0.2.2`), die nur innerhalb des virt-launcher Pods sichtbar ist.
- Traffic nach außen wird via **NAT (iptables/nftables) maskiert** — die Quell-IP wird zur Pod-IP umgeschrieben.
- Die VM ist von außen **nicht direkt erreichbar** — nur über Kubernetes Services mit Port-Forwarding oder NodePort/LoadBalancer.
- `virtctl port-forward` und `kubectl port-forward` funktionieren hier gut.
- Standardmodus, wenn man einfach Internet-Zugang für die VM will.
- Funktioniert mit **jedem CNI-Plugin** (Flannel, Calico, etc.), weil die Pod-IP nach außen verwendet wird.

### Datenfluss (ausgehend)
```
VM (10.0.2.2) → virt-launcher (NAT/masquerade) → Pod-IP → Node → Internet
```

### Datenfluss (eingehend via Service)
```
Client → LoadBalancer/NodePort → Pod-IP → iptables DNAT → VM (10.0.2.2)
```

---

## Bridge

```yaml
interfaces:
  - name: default
    bridge: {}
```

- Die VM wird über eine **Linux Bridge direkt ans Pod-Netzwerk** angebunden.
- Die VM bekommt die **IP des Pods** (oder eine eigene IP im Pod-Subnetz) — sie ist ein **vollwertiger Netzwerk-Teilnehmer**.
- Die VM ist direkt per ihrer IP erreichbar, ohne NAT.
- Geringerer Overhead, aber **abhängig vom CNI** — nicht alle CNI-Plugins unterstützen bridge mode problemlos.
- Wird verwendet, wenn die VM direkt auf Layer-2/3 kommunizieren soll (z.B. für Multus-Interfaces, SR-IOV).

### Datenfluss
```
VM (Pod-IP) ↔ Linux Bridge ↔ Pod-Netzwerk-Interface ↔ Node
```

---

## Vergleich auf einen Blick

| Eigenschaft              | masquerade             | bridge                     |
|--------------------------|------------------------|----------------------------|
| VM-IP                    | intern (10.0.2.x)      | direkt im Pod-Netzwerk     |
| NAT                      | ja (iptables)          | nein                       |
| Direkt erreichbar        | nein (nur via Service) | ja                         |
| CNI-Kompatibilität       | universell             | CNI-abhängig               |
| Overhead                 | leicht höher (NAT)     | geringer                   |
| Multus-fähig             | eingeschränkt          | ja, typischer Anwendungsfall |
| Empfehlung               | Standard / einfach     | fortgeschritten / Multus   |

---

## Typische Verwendung in den Labs

In Lab 05 (`05_create-vm/`) wird standardmäßig **masquerade** verwendet:

```yaml
networks:
  - name: default
    pod: {}
interfaces:
  - name: default
    masquerade: {}
```

Für VMs mit Multus-Zusatzinterfaces (mehrere NICs) kommt **bridge** ins Spiel — dann gibt es ein masquerade Interface für den Default-Pod-Traffic und ein bridge Interface für das Zusatznetzwerk.

# Trunk Pod

Ein **Trunk Pod** ist im Kubernetes/KubeVirt-Kontext ein privilegierter Pod, der als Netzwerk-Vermittler fungiert und mehrere VLANs über eine einzige Netzwerkschnittstelle transportiert (trunking).

## Im Kontext von Multus CNI

- Multus läuft in der "thick" Variante als DaemonSet — jedes Node hat einen Multus-Pod
- Dieser Pod hat erhöhte Netzwerkrechte und kann sekundäre Netzwerkinterfaces für andere Pods bereitstellen
- Er delegiert die eigentliche CNI-Konfiguration an andere Plugins (z.B. bridge, macvlan)

## Im Kontext von KubeVirt VMs

- Wenn eine VM mehrere Netzwerke benötigt (via Multus), kann ein "Trunk" Interface genutzt werden, das VLAN-Tags durchleitet
- Die VM bekommt dann tagged traffic auf einem Interface und kann selbst VLANs terminieren

## Netzwerkpfad

```
VM → veth → bridge → Trunk Interface (VLAN-tagged) → physisches Netz
```

Ein falsch konfigurierter Trunk-Mode kann zu CrashLoopBackOff bei Multus führen.

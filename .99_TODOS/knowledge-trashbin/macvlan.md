# macvlan

**macvlan** ist ein Linux-Kernel-Feature, das es ermöglicht, einem physischen Netzwerkinterface mehrere virtuelle Interfaces mit je eigener MAC-Adresse zuzuweisen.

## Grundprinzip

Normale Container/Pods teilen sich eine Bridge und kommunizieren über NAT mit dem physischen Netz. Mit macvlan bekommt jeder Pod eine eigene MAC-Adresse und erscheint dem Netzwerk gegenüber wie ein eigenständiges Gerät.

```
physisches Interface (eth0)
    ├── macvlan0  (MAC: aa:bb:cc:01)  → Pod A
    ├── macvlan1  (MAC: aa:bb:cc:02)  → Pod B
    └── macvlan2  (MAC: aa:bb:cc:03)  → Pod C
```

## Modi

| Modus | Beschreibung |
|-------|-------------|
| `bridge` | Sub-Interfaces können direkt miteinander kommunizieren |
| `private` | Sub-Interfaces können nicht miteinander kommunizieren |
| `vepa` | Traffic wird zum Switch geschickt, der ihn zurückleitet |
| `passthru` | Exklusive Nutzung des physischen Interfaces |

## Einsatz in Kubernetes / KubeVirt

- Multus CNI kann macvlan als sekundäres Netzwerkplugin verwenden
- Pods/VMs bekommen damit direkt eine IP aus dem physischen Netz (kein NAT)
- Nützlich wenn VMs direkt im LAN sichtbar sein sollen

## Einschränkung

Host und macvlan Sub-Interfaces können **nicht direkt miteinander** kommunizieren — das physische Interface und seine macvlan-Kinder sind voneinander isoliert. Workaround: ein eigenes macvlan-Interface auf dem Host anlegen.

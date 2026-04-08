# virt-launcher

Der `virt-launcher` ist ein **Pod pro VM** — KubeVirt startet für jede VMI einen eigenen Pod.

## Was er enthält

- `compute` Container — führt QEMU/KVM aus, startet die eigentliche VM
- `guest-console-log` Container — sammelt die serielle Konsolen-Ausgabe der VM

## Was er macht

```
┌─────────────────────────────────┐
│      virt-launcher Pod          │
│                                 │
│  ┌──────────────────────────┐   │
│  │   compute container      │   │
│  │   - startet libvirt      │   │
│  │   - startet QEMU/KVM     │   │
│  │   - verwaltet VM-Lifecycle│  │
│  └──────────────────────────┘   │
│                                 │
│  ┌──────────────────────────┐   │
│  │ guest-console-log        │   │
│  │ - liest serielle Konsole │   │
│  └──────────────────────────┘   │
└─────────────────────────────────┘
         ▲              ▲
         │              │
    virt-handler    virt-api
   (Node-Daemon)   (API Server)
```

## Warum ein Pod pro VM?

- Kubernetes verwaltet den VM-Lifecycle wie einen normalen Workload (Scheduling, Ressourcen, Namespaces)
- Netzwerk der VM = Netzwerk des Pods (daher `masquerade` Interface)
- Stirbt der Pod → KubeVirt startet ihn neu (je nach `runStrategy`)

## virt-handler

`virt-handler` läuft als DaemonSet auf jedem Node, kommuniziert mit dem `virt-launcher` und weist ihn an die VM zu starten/stoppen.

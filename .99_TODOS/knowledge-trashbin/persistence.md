
## storageclasses

Beide kommen von Longhorn, haben aber unterschiedliche Verwendungszwecke:

- longhorn (default) — dynamischer Provisioner. Kubernetes erstellt automatisch ein Longhorn-Volume wenn ein PVC angelegt wird.
  Standard für fast alles (DataVolumes, VMs).
- longhorn-static — für statisch pre-provisionierte Volumes. Man legt das Longhorn-Volume manuell an und bindet es dann über einen
  PV/PVC. Wird gebraucht wenn man ein bestehendes Volume mit bestimmten Daten einbinden will, ohne dass Kubernetes es automatisch
  erstellt.

  Für KubeVirt/CDI reicht longhorn (default) — wird automatisch genutzt wenn keine storageClassName angegeben ist, wie in der aktuellen
  my-vm.yaml.

## Block mode für vm images

⏺ Block mode ist für VM-Images besser aus folgenden Gründen:

  Performance

- QEMU/KVM kann direkt auf das Block Device schreiben — ohne Filesystem-Overhead (kein ext4/xfs dazwischen)
- Weniger I/O-Latenz, besonders bei random reads/writes (typisch für VMs)

  Korrektheit

- VM-Images verwalten ihr eigenes internes Filesystem — ein zweites Filesystem drumherum (Filesystem-Mode) ist redundant und kann
  Caching-Konflikte verursachen
- Block mode vermeidet doppeltes Page-Caching (Host-Kernel + Guest-Kernel)

  CDI/KubeVirt Empfehlung

- KubeVirt empfiehlt offiziell volumeMode: Block für VM-Disks
- CDI kann Block-Volumes effizienter befüllen (direktes dd statt Datei schreiben)
schr

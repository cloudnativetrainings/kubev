# Empty Disk an eine VM attachen

## 1. Disk in `devices.disks` hinzufügen

```yaml
devices:
  disks:
    - name: rootdisk
      disk:
        bus: virtio
    - name: cloudinit
      disk:
        bus: virtio
    - name: datadisk        # neu
      disk:
        bus: virtio
```

## 2. Volume in `volumes` hinzufügen

```yaml
volumes:
  - name: rootdisk
    dataVolume:
      name: root-volume
  - name: cloudinit
    cloudInitNoCloud:
      ...
  - name: datadisk          # neu
    dataVolume:
      name: data-volume
```

## 3. DataVolumeTemplate hinzufügen

```yaml
dataVolumeTemplates:
  - metadata:
      name: root-volume
    spec:
      ...
  - metadata:
      name: data-volume     # neu
    spec:
      source:
        blank: {}           # leere Disk
      pvc:
        accessModes:
          - ReadWriteOnce
        volumeMode: Block
        storageClassName: longhorn
        resources:
          requests:
            storage: 20Gi
```

Der entscheidende Unterschied zum `root-volume`: `source: blank: {}` statt `source: pvc: ...`

## In der VM formatieren

Nach dem Start muss die Disk noch formatiert werden:

```bash
lsblk                          # neue Disk finden (z.B. vdb)
mkfs.ext4 /dev/vdb
mount /dev/vdb /mnt/data
```

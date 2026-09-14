
# Persistence

In this lab you will learn how to add an empty disk to your VM.

## Preparations

Adapt the VM definition in the file `/training/my-vm.yaml`.

```yaml
# spec.template.spec.domain.devices.disks
- name: datadisk
  disk:
    bus: virtio

# spec.template.spec.volumes
- name: datadisk
  dataVolume:
    name: data-volume

# spec.dataVolumeTemplates
- metadata:
    name: data-volume
  spec:
    source:
      blank: {}
    pvc:
      accessModes:
        - ReadWriteOnce
      volumeMode: Filesystem
      storageClassName: longhorn
      resources:
        requests:
          storage: 1Gi
```

## Adding the disk

```bash
# apply the changes
kubectl apply -f /training/my-vm.yaml
```

```bash
# watch the PV being created and bound
watch -n 1 kubectl get pods,vm,vmi,pv,pvc
```

```bash
# take a look at the datavolumes
kubectl get datavolumes
```

```bash
# adding disks involves restarting the vm
virtctl restart my-vm
```

```bash
# check in VM
kubectl get nodes -o wide
```

```bash
# check in VM
ssh -i /root/.ssh/gcp-kubev root@<FILL-IN-INTERNAL-IP-OF-WORKER-NODE> -p 30022
```

```bash
# list all block devices on the vm
lsblk
```

```bash
# create a new directory
mkdir -p /mnt/data
```

```bash
# format disk
mkfs.ext4 /dev/vdc
```

```bash
# mount disk
mount /dev/vdc /mnt/data/
```

Note: for making the mount persistent across vm restarts you have to adapt `/etc/fstab`.

```bash
# verify
echo something >> /mnt/data/some.file
```

```bash
# verify
cat /mnt/data/some.file
```

```bash
# exit the vm
exit
```

## Verify on the worker node

```bash
# get the pvc name of the data-volume
kubectl get pvc
```

```bash
# ssh into the worker node
ssh worker-node
```

```bash
# show the content of the pvc directory
ls -alh /var/lib/longhorn/replicas/<FILL-IN-THE-PVC-NAME>-.../
```

```bash
# exit the worker node
exit
```

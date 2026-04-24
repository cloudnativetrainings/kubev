
# Persistence

In this lab you will learn how to add an empty disk to you VM.

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

# watch the PV being created and bound
watch -n 1 kubectl get pods,vm,vmi,pv,pvc

# take a look at the datavolumes
kubectl get datavolumes

# restart vm - TODO do i need this?
virtctl restart my-vm

# check in VM
kubectl get nodes -o wide
ssh -i /root/.ssh/gcp-kubev root@<INTERNAL-IP-OF-WORKER-NODE> -p 30022

# list all block devices on the vm
lsblk

# note that the new disk is not shown, you need to restart the vm
exit
virtctl restart my-vm

# re-connect after the restart is finished
ssh -i /root/.ssh/gcp-kubev root@<INTERNAL-IP-OF-WORKER-NODE> -p 30022

# now a new block device of type disk exists
lsblk

# create a new directory
mkdir -p /mnt/data

# format and mount the new disk
mount -t ext4 /dev/vdc /mnt/data 

# note for making the mount persistent accross vm restarts you have to adapt /etc/fstab

# verify
echo something >> /mnt/data/some.file
cat /mnt/data/some.file

# exit the vm
exit
```

## Verify on the worker node

```bash
# get the pvc name of the data-volume
kubectl get pvc

# ssh into the worker node
kubectl get nodes -o wide
ssh -i /root/.ssh/gcp-kubev root@<FILL-IN-THE-INTERNAL-IP-OF-THE-WORKER-NODE>

# show the content of the pvc directory
ls -alh /var/lib/longhorn/replicas/<FILL-IN-THE-PVC-NAME>-.../

# exit the worker node
exit
```


```yaml



# in my-vm.yaml

# spec.template.spec.domain.devices.disks
    - name: datadisk        # neu
      disk:
        bus: virtio

# spec.template.spec.domain.volumes
  - name: datadisk          # neu
    dataVolume:
      name: data-volume

# spec.dataVolumeTemplates
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

```bash

# apply
kubectl apply -f /training/my-vm-with-datadisk.yaml
watch -n 1 kubectl get pods,vm,vmi,pv,pvc

kubectl get datavolumes

# restart vm - TODO do i need this?
virtctl restart my-ubuntu-vm

# check in VM
ssh -i .secrets/thor root@192.168.99.100 

lsblk
mkfs.ext4 /dev/vdc

blkid /dev/vdc
mkdir /mnt/data
echo "UUID=b1e62366-366e-4ae0-bcd1-5167702fd4fa /mnt/data ext4 defaults 0 2" >> /etc/fstab

systemctl daemon-reload
mount -a

shutdown -r now

ssh -i .secrets/thor root@192.168.99.100 

echo "hello from vm" >> /mnt/data/hello.txt
cat /mnt/data/hello.txt 
exit


```

# check on worker node

```bash

kubectl get pvc


ssh -i .secrets/thor root@192.168.99.27

ls -alh /var/lib/longhorn/replicas/pvc-319ed899-1362-4cd5-944a-27df49f953aa-97d3443b

```

# TODO training mats change servicetype

# TODO training mats change datadisk

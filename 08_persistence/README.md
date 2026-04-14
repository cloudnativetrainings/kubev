
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
        volumeMode: Filesystem
        storageClassName: longhorn
        resources:
          requests:
            storage: 20Gi


```

# TODO shrink down disk sizes or increase disk size on host

# nope I guess the problem was the same name of the vm

```bash

# apply
kubectl apply -f /training/my-vm-with-datadisk.yaml
watch -n 1 kubectl get pods,vm,vmi,pv,pvc

kubectl get datavolumes

# restart vm - TODO do i need this?
virtctl restart my-ubuntu-vm

# check in VM
kubectl get nodes -o wide
ssh -i /root/.ssh/gcp-kubev root@10.156.0.2 -p 30022
hostname


lsblk
mkfs.ext4 /dev/vdc

blkid /dev/vdc
mkdir -p /mnt/data

mount -t ext4 /dev/vdc /mnt/data 
lsblk

echo something >> /mnt/data/some.file

# or via /etc/fstab
echo "UUID=f05887ae-77ad-4518-a36e-f8a5ff836bc4 /mnt/data ext4 defaults 0 2" >> /etc/fstab

systemctl daemon-reload
mount -a

shutdown -r now

ssh -i /root/.ssh/gcp-kubev.pub root@192.168.99.100 

echo "hello from vm" >> /mnt/data/hello.txt
cat /mnt/data/hello.txt 
exit


```

# check on worker node

```bash

kubectl get pvc


ssh -i /root/.ssh/gcp-kubev.pub root@192.168.99.27

ls -alh /var/lib/longhorn/replicas/pvc-319ed899-1362-4cd5-944a-27df49f953aa-97d3443b

```

# TODO training mats change servicetype

# TODO training mats change datadisk

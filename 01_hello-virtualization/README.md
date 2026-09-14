
# Hello Virtualization

In this lab you will learn how to create, start and use a VM on some Linux machine.

## Preparation steps

```bash
# copy the private key to the worker node (for being able to ssh into the vm we will create)
scp /training/.secrets/gcp-kubev worker-node:/root/.ssh/
```

```bash
# ssh into the worker node
ssh worker-node
```

```bash
# change permissions of private key
chmod 0400 /root/.ssh/gcp-kubev
```

```bash
# verify private key is in place and has proper permissions
ls -alh /root/.ssh/
```

```bash
# install needed tools
apt update
```

```bash
# install needed tools
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cpu-checker cloud-image-utils
```

```bash
# check if kvm is setup properly
kvm-ok
```

```bash
# make use of virsh to check the running vms (which are none for now)
virsh list --all
```

```bash
# list virtual hdds
ls -alh /var/lib/libvirt/images/
```

```bash
# list vm setup
ls -alh /etc/libvirt/qemu/
```

## Create a VM

```bash
# download ubuntu image which supports cloud-init
wget https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img
```

```bash
# copy img file to where libvirt expects it
cp ubuntu-24.04-server-cloudimg-amd64.img /var/lib/libvirt/images/
```

```bash
# change ownership
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/ubuntu-24.04-server-cloudimg-amd64.img
```

```bash
# create an iso which will allow you to connect to the vm afterwards
# note you are on the worker node, you have to use vi on the worker node and not the IDE running on the jumphost
vi user-data.yaml
```

```bash
# create an iso which will allow you to connect to the vm afterwards
# note you are on the worker node, you have to use vi on the worker node and not the IDE running on the jumphost
cloud-localds seed.iso user-data.yaml
```

```bash
# copy img file to where libvirt expects it
cp seed.iso /var/lib/libvirt/images/
```

```bash
# change ownership
chown libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/seed.iso
```

```bash
# verify
ls -alh /var/lib/libvirt/images/
```

```bash
# create the vm
virt-install \
  --name my-vm \
  --memory 4096 \
  --vcpus 2 \
  --os-variant ubuntu24.04 \
  --disk path=/var/lib/libvirt/images/ubuntu-24.04-server-cloudimg-amd64.img,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/seed.iso,device=cdrom \
  --network network=default \
  --import \
  --graphics none \
  --noautoconsole \
  --serial pty
```

```bash
# check the qemu logs
cat /var/log/libvirt/qemu/my-vm.log
```

```bash
# check the qemu logs
cat /etc/libvirt/qemu/my-vm.xml
```

```bash
# verify vm was created and is in state running
virsh list --all
```

```bash
# access the vm via virsh
virsh console my-vm
```

```bash
# access the vm via ssh
virsh domifaddr my-vm # to get the ip-address
```

```bash
# access the vm via ssh
ssh -v -i /root/.ssh/gcp-kubev root@<FILL-IN-IP-OF-VM>
```

## Destroy VM

```bash
virsh list --name
```

```bash
virsh destroy my-vm
```

```bash
virsh undefine my-vm --remove-all-storage
```

```bash
# verify
virsh list --all
```

```bash
# verify
ls -alh /var/lib/libvirt/images/
```

```bash
# verify
ls -alh /etc/libvirt/qemu/
```

```bash
# go back to the jumphost
exit
```

## Debug VM creation

If you cannot reach the VM after creation, you can do the following to get logs of the VM.

```bash
# instead of this parameter in virt-install
  --serial pty
# use
  --serial file,path=/tmp/my-vm-serial.log
```

```bash
# afterwards you have a log file for debugging
tail -f /tmp/my-vm-serial.log
```

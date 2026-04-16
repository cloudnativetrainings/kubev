
# Hello Virtualization

In this lab you will learn how to create, start and use a VM on some Linux Machine.

## Preparation steps

```bash
# ssh into the worker node
ssh worker-node 

# install needed tools
apt update
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cpu-checker cloud-image-utils

# check if kvm is setup properly
kvm-ok

# make use of virsh to check the running vms (which are none for now)
virsh list --all

# list virtual hdds
ls -alh /var/lib/libvirt/images/

# list vm setup
ls -alh /etc/libvirt/qemu/

# show logs
ls -alh /var/log/libvirt/qemu/
```

## Create a VM

```bash
# download some cloud image
wget https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img

# create an iso which will allow you to connect to the vm afterwards
# note you are on the worker node, you have to use vi on the worker node and not the IDE running on the jumphost
vi user-data.yaml
vi network-config
cloud-localds seed.iso user-data.yaml --network-config=network-config

# copy the iso and the image where libvirt expects those files
cp seed.iso /var/lib/libvirt/images/
cp ubuntu-24.04-minimal-cloudimg-amd64.img /var/lib/libvirt/images/
chown libvirt-qemu:libvirt-qemu \
  /var/lib/libvirt/images/seed.iso \
  /var/lib/libvirt/images/ubuntu-24.04-minimal-cloudimg-amd64.img

# verify
ls -alh /var/lib/libvirt/images/

# create the vm
virt-install \
  --name my-vm \
  --memory 2048 \
  --vcpus 2 \
  --os-variant ubuntu24.04 \
  --disk path=/var/lib/libvirt/images/ubuntu-24.04-minimal-cloudimg-amd64.img,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/seed.iso,device=cdrom \
  --network network=default \
  --import \
  --graphics none \
  --noautoconsole

# verify vm was created and is in state running
virsh list --all

# TODO no ip addr on GCE, does not work...
virsh console my-vm  
virsh domifaddr my-vm
ssh -v -i /root/.ssh/gcp-kubev root@<FILL-IN-IP-OF-VM>
```

## destroy vm

```bash
virsh list --name
virsh destroy my-vm
virsh undefine my-vm --remove-all-storage

# verify
virsh list --all
ls -alh /var/lib/libvirt/images/
ls -alh /etc/libvirt/qemu/
cat /var/log/libvirt/qemu/my-vm.log

# go back to the jumphost
exit
```

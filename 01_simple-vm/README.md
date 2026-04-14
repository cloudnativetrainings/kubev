
# kvm

## create vm

```bash

# ssh worker node
ssh worker-node 

lscpu | grep Virtualization

# install kvm
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cpu-checker

kvm-ok

virsh list --all

# list virtual hdds
ls -alh /var/lib/libvirt/images/

# list vm setup
ls -alh /etc/libvirt/qemu/

# show logs
ls -alh /var/log/libvirt/qemu/

# create vm
apt-get install -y cloud-image-utils
wget https://cloud-images.ubuntu.com/minimal/releases/noble/release/ubuntu-24.04-minimal-cloudimg-amd64.img
create user-data.yaml
vi user-data.yaml
cloud-localds seed.iso user-data.yaml
cp /root/seed.iso /var/lib/libvirt/images/
cp /root/ubuntu-24.04-minimal-cloudimg-amd64.img /var/lib/libvirt/images/
chown libvirt-qemu:libvirt-qemu \
  /var/lib/libvirt/images/seed.iso \
  /var/lib/libvirt/images/ubuntu-24.04-minimal-cloudimg-amd64.img

virt-install \
  --name my-vm \
  --memory 4096 \
  --vcpus 2 \
  --os-variant ubuntu24.04 \
  --disk path=/var/lib/libvirt/images/ubuntu-24.04-minimal-cloudimg-amd64.img,format=qcow2,bus=virtio \
  --disk path=/var/lib/libvirt/images/seed.iso,device=cdrom \
  --network network=default \
  --import \
  --graphics none \
  --noautoconsole

virsh list --all

# TODO no ip addr, does not work...

virsh console my-vm  
# cloudinit probably running
#  Escape character is ^] (Ctrl + ])


virsh domifaddr my-vm
ssh -v -i /root/.ssh/id_ed25519   ubuntu@192.168.122.155
```

## destroy vm

```bash
virsh list --name
virsh destroy my-vm
virsh undefine my-vm --remove-all-storage

virsh list --all
ls -alh /var/lib/libvirt/images/
ls -alh /etc/libvirt/qemu/
ls -alh /var/log/libvirt/qemu/
cat /var/log/libvirt/qemu/my-vm.log

exit
```

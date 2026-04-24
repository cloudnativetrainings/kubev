
# Hello Virtualization

In this lab you will learn how to create, start and use a VM on some Linux Machine.

## Preparation steps

```bash
# copy the private key to the worker node
scp /training/.secrets/gcp-kubev worker-node:/root/.ssh/

# ssh into the worker node
ssh worker-node 

# change permissions of private key
chmod 0400 /root/.ssh/gcp-kubev

# verify private key is in place and has proper permissions
ls -alh /root/.ssh/

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
```

## Create a VM

```bash
# download ubuntu image which supports cloud-init
wget https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.img

# create an iso which will allow you to connect to the vm afterwards
# note you are on the worker node, you have to use vi on the worker node and not the IDE running on the jumphost
vi user-data.yaml
cloud-localds seed.iso user-data.yaml

# copy the iso and the image where libvirt expects those files
cp seed.iso /var/lib/libvirt/images/
cp ubuntu-24.04-server-cloudimg-amd64.img /var/lib/libvirt/images/
chown libvirt-qemu:libvirt-qemu \
  /var/lib/libvirt/images/seed.iso \
  /var/lib/libvirt/images/ubuntu-24.04-server-cloudimg-amd64.img

# verify
ls -alh /var/lib/libvirt/images/

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

# check the qemu logs
cat /var/log/libvirt/qemu/my-vm.log
cat /etc/libvirt/qemu/my-vm.xml

# verify vm was created and is in state running
virsh list --all

# access the vm via virsh
virsh console my-vm

# access the vm via ssh
virsh domifaddr my-vm # to get the ip-address
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

# go back to the jumphost
exit
```

## Debug VM creation

If you cannot reach the VM after creation you can do the following to get logs of the VM.

```bash
# instead of this parameter in virt-install
  --serial pty
# use
  --serial file,path=/tmp/my-vm-serial.log
  
# afterwards you have a log file for debugging
tail -f /tmp/my-vm-serial.log
```

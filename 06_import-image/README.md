
# Import a VM Image

In this lab you will learn how to create an image which will be used for creating VMs afterwards.

```bash
# inspect the file /training/ubuntu-image-datavolume.yaml
code /training/ubuntu-image-datavolume.yaml
```

```bash
# apply the datavolume
kubectl apply -f /training/ubuntu-image-datavolume.yaml
```

```bash
# watch the process
watch -n 1 kubectl get pods,datavolume,pv,pvc
```

> Note: a pod called importer-prime-... gets started which will download the image and store it in a PV. Based on this image you will create a VM afterwards.

<!-- TODO kubeconfig in welcome.sh does not work -->
<!-- TODO there is no trainingrc file -->
<!-- TODO no CCM by design? -->
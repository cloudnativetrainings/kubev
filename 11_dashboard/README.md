# Installing kubermatic-virtualization-dashboard to your environment

In this lab you will learn how to install the kubermatic-virtualization-dashboard to your environment.

See [documentation](https://docs.kubermatic.com/kubermatic-virtualization/v1.1.0/configuration-guide/#dashboard) for details.

> Note: for the sake of simplicity in the workshop we will make use of basic auth. This means we do not have to care about dex/certmanager/ingress/... This only makes sense in the workshop installation. Do not do this in real installations, because basic auth is not secure at all.

## Install the Dashboard

Add the following to the file named `/training/cluster.yaml`.

<!-- TODO add gcloud vor checking stuff in cli -->

```yaml
dashboard:
  enabled: true
  auth:
    basic: {}
```

Apply the change. Note you may have to reset the env vars if you are in a different bash now.

```bash
# set the quay username
export KUBEV_USERNAME=<FILL-IN-QUAY-USERNAME>
```

```bash
# set the quay password
export KUBEV_PASSWORD=<FILL-IN-QUAY-PASSWORD>
```

<!-- TODO did not work due to problems on worker with dns resolution

hostname -f
hostname: Temporary failure in name resolution
root@kvw-hubert-01:~# echo "127.0.1.1 $(hostname)" | sudo tee -a /etc/hosts
127.0.1.1 kvw-hubert-01.europe-west3-a.c.kv-del-codespaces-01.internal
root@kvw-hubert-01:~# hostname -f
kvw-hubert-01.europe-west3-a.c.kv-del-codespaces-01.internal
root@kvw-hubert-01:~# 
 -->

```bash
# apply
kubev apply -f /training/cluster.yaml -y
```

## Use the Dashboard

```bash
# verify everything is in a proper state
kubectl -n kubermatic-virtualization get all
```

```bash
# take a look at the service
kubectl -n kubermatic-virtualization get svc kubev-dashboard
```

```bash
# change the type of the service from ClusterIP to NodePort
kubectl -n kubermatic-virtualization edit svc kubev-dashboard
```

```bash
# get the nodeport of the service
kubectl -n kubermatic-virtualization get svc kubev-dashboard
```

```bash
# get the external ip of the worker node
kubectl get nodes -o wide
```

<!-- TODO make this easier to consume -->

```bash
# get the credentials
kubectl -n kubermatic-virtualization get secret kubev-basic-auth -o yaml
```

The username is `admin`.

```bash
# get the password
echo <FILL-IN-THE-PASSWORD> | base64 -d
```

<!-- There is no external ip of the worker node!!!!  via kubectl but via console and readme -->

<!-- TODO get rid of # on doing echo commands -->

<!-- TODO does not work no vms shown in ui -->

The url of the dashboard is `http://<EXTERNAL-IP-OF-WORKER-NODE>:<NODEPORT-OF-DASHBOARD-SERVICE>`.

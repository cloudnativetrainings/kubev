# Installing kubermatic-virtualization-dahboard to your environment

In this lab you will learn how to install kubermatic-virtualization-dashboard to your environment.

See [documentation](https://docs.kubermatic.com/kubermatic-virtualization/v1.1.0/configuration-guide/#dashboard) for details.

> Note: for the sake of simplicity in the workshop we will make us of basic auth. This allows us not having to care about dex/certmanager/ingress/... This only makes sense in the workshop installation. Do not do this in real installations, due to basic auth is not secure at all!!!

## Install the Dashboard

Add the following to the file named `/training/cluster.yaml`.

```yaml
dashboard:
  enabled: true
  auth:
    basic: {}
```

Apply the change. Note you may have to reset the env vars if you are on a different bash now.

```bash
# set the quay username
export KUBEV_USERNAME=<FILL-IN-QUAY-USERNAME>

# set the quay password
export KUBEV_PASSWORD=<FILL-IN-QUAY-PASSWORD>

# apply
kubev apply -f /training/cluster.yaml -y
```

## Use the Dashboard

```bash
# verify everything is in a proper state
kubectl -n kubermatic-virtualization get all

# take a look at the service
kubectl -n kubermatic-virtualization get svc kubev-dashboard     

# change the type of the service from ClusterIP to NodePort
kubectl -n kubermatic-virtualization edit svc kubev-dashboard     

# get the nodeport of the service
kubectl -n kubermatic-virtualization get svc kubev-dashboard 

# get the external ip of the worker node
kubectl get nodes -o wide

# get the credenitals
kubectl -n kubermatic-virtualization get secret kubev-basic-auth -o yaml

# the username is `admin`

# get the password
echo <FILL-IN-THE-PASSWORD> | base64 -d

# the url of the dashboard is http://<EXTERNAL-IP-OF-WORKER-NODE>:<NODEPORT-OF-DASHBOARD-SERVICE>
```

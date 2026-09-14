# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

A KubeVirt / Kubermatic Virtualization training environment. Trainees connect to a code-server "jumphost" container and run labs that install a Kubernetes cluster on two GCE VMs (controlplane-node, worker-node) via the `kubev` binary, then create and manage KubeVirt VMs on top of it.

## Training container

The jumphost is a code-server (browser VS Code) container built from `ubuntu:26.04`, defined by `container-image/dockerfile`. The repo `makefile` wraps the docker workflow (image tag `kubev:0.0.0`, container/hostname `kubermatic-virtualization-workshop`):

```bash
make lint    # hadolint ./container-image/dockerfile
make build   # depends on lint; builds the image
make run     # depends on build; runs detached as --name/--hostname kubermatic-virtualization-workshop, -p 8080:8080, -v $PWD:/training, --restart=always
make clear   # docker rmi kubev:0.0.0
```

Equivalent raw `docker` invocation (if `make` isn't available):

```bash
docker build -t kubev:0.0.0 ./container-image/
docker run -d --name kubermatic-virtualization-workshop -p 8080:8080 -v "$PWD":/training kubev:0.0.0
```

The container runs `code-server` with `--auth none --bind-addr 0.0.0.0:8080` (plus `--disable-telemetry --disable-update-check --disable-workspace-trust --disable-getting-started-override`); trainees access it in a browser. There is no authentication on the IDE itself — only ever expose it on `localhost`.

The default shell is zsh (oh-my-zsh + powerlevel10k). `/root/.trainingrc` (sourced by `.zshrc`) sets `alias code=code-server` and shell completions for yq, kubectl, helm, helmfile, virtctl. `PATH` includes `/root/.krew/bin` (set via `ENV`, not `.trainingrc`). Every new shell runs `container-image/welcome.sh`, which banners the installed tool versions and echoes `$KUBECONFIG`.

**`KUBECONFIG` is *not* preset anywhere in the image** (the `export KUBECONFIG=/training/.secrets/kubev-cluster-kubeconfig` line was dropped from `.trainingrc` in the "consolidate ide look and feel" rework) — despite lab 04's README still describing the kubeconfig move as happening "to the location `$KUBECONFIG` is set, for convenience." Trainees currently need to export it themselves; treat this as a likely regression, not an intentional change, if asked to investigate broken `kubectl`/`kubev` commands.

Tooling baked into the image via pinned `ARG`s in `container-image/dockerfile` (resolved per-arch via `$TARGETARCH`): yq (`YQ_VERSION=4.53.6`), code-server (`CODE_SERVER_VERSION=4.135.0`), kubectl (`K8S_VERSION=1.36.4`), krew (`KREW_VERSION=0.5.0`), helm (`HELM_VERSION=4.2.4`), helmfile (`HELMFILE_VERSION=1.7.4`), virtctl (`VIRTCTL_VERSION=1.6.5`), plus kubectx, VS Code extensions (prettier, YAML, Terraform), and standard net/CLI utilities (curl, wget, nmap, traceroute, arping, netcat-openbsd, apache2-utils, htop, dnsutils). **Do not bump these pins casually** — labs depend on the exact toolchain.

## Lab sequence

Labs are numbered directories at the repo root, each with a single `README.md`. The numbering has gaps — there is no `03_*`, `05_*`, or `10_*`.

1. `01_hello-virtualization/` — provision a plain libvirt/KVM VM on the worker node directly (no Kubernetes) using `virt-install` + cloud-init.
2. `02_install-binaries/` — download the `kubermatic-virtualization` binary from Quay via `kubermatic-ee-downloader` (using `KUBEV_USERNAME`/`KUBEV_PASSWORD` workshop credentials), then install it to `/usr/local/bin/kubev`.
3. `04_create-kubermatic-virtualization-cluster/` — `kubev apply -f /training/cluster.yaml -y` provisions the K8s cluster via kubeone and installs kubev components. The produced `kubev-cluster-kubeconfig` is then moved into `.secrets/` so the `KUBECONFIG` env var resolves.
4. `06_import-image/` — apply `ubuntu-image-datavolume.yaml` so CDI downloads the Ubuntu cloud image into a Longhorn PVC.
5. `07_create-vm/` — splice `user-data.yaml` into `my-vm.yaml`, then `kubectl apply` the VM.
6. `08_connect-to-vm/` — connect via `virtctl ssh`, `virtctl console`, NodePort service (`my-vm-service.yaml`).
7. `09_persistence/` — add a blank `DataVolume` disk to `my-vm.yaml`, restart the VM, format and mount inside the guest, verify on the worker via Longhorn replicas.
8. `11_dashboard/` — extend `cluster.yaml` with a `dashboard:` block (basic auth), re-apply with `kubev`, expose the `kubev-dashboard` service via NodePort, read credentials from the `kubev-basic-auth` secret.
9. `99_teardown/` — `teardown.sh` runs `kubeadm reset` and `apt remove` of k8s packages; the README ssh's it to both nodes and cleans local kubeconfig/binary files.

## Top-level YAML files used by labs

All referenced as `/training/<file>` from the labs because the repo is mounted at `/training` inside the container.

- `cluster.yaml` — `KubeVCluster` spec. Internal IPs of control-plane / worker VMs are placeholders (`<FILL-IN-INTERNAL-IP-OF-*>`) that trainees fill in from `.secrets/README.md`. Network CIDR `172.25.0.0/24`, MetalLB pool `10.156.0.193-10.156.0.254` (GCE-routable range), storage: Longhorn.
- `my-vm.yaml` — `kubevirt.io/v1 VirtualMachine`, 2 vCPU / 2Gi, sources rootdisk from PVC `ubuntu-image`. The `cloudinit` volume's `userData` is a `<FILL-IN-CLOUD-CONFIG>` placeholder spliced in during lab 07.
- `ubuntu-image-datavolume.yaml` — CDI `DataVolume` pulling Ubuntu 24.04 noble cloudimg into a 10Gi Longhorn PVC.
- `user-data.yaml` — cloud-init user data fragment pasted into `my-vm.yaml`. Contains the (intentional) training root password `chang3Me#`.
- `my-vm-service.yaml` — Service exposing the VM (NodePort 30022 + LoadBalancer).
- `metallb.yaml` — fallback `IPAddressPool` if kubev's installer doesn't create one (workaround for kubermatic-virtualization issue #149).
- `training-application.yaml` — sample app exposed via LoadBalancer (MetalLB).
- `network-config` — cloud-init network config snippet.

## Kubeconfig lifecycle

`kubev apply` writes the produced admin kubeconfig to `/training/kubev-cluster-kubeconfig` (repo root inside the container, which is the host repo dir). Lab 04 immediately moves it to `/training/.secrets/kubev-cluster-kubeconfig` where `$KUBECONFIG` points. **Any leftover `kubev-cluster-kubeconfig` at the repo root is a full cluster-admin credential** — `.gitignore` covers `*kubeconfig` so it won't be committed, but it must not be shared (zip, tarball, demo screen-share). Lab 99 cleans both locations.

## Trainee setup expectations

Per repo `README.md`, trainees receive a `.secrets/` bundle out-of-band containing GCP SSH keys (`gcp-kubev`, `gcp-kubev.pub`, `gcp-kubev-config`) and a `README.md` with the VM IPs. They drop it into `/training/.secrets/` and `install` the keys into `/root/.ssh/`. After that, `ssh controlplane-node` and `ssh worker-node` resolve via the provided SSH config.

## Known issues (called out in labs)

- MetalLB external IPs may not be reachable from outside the GCE network — labs note "TODO: GCP networking / firewall issue" for the LoadBalancer paths in `08_connect-to-vm`.
- `kubectl port-forward` → ssh into the VM no longer works ("TODO does not work anymore" in lab 08).
- MetalLB `IPAddressPool` sometimes isn't created by the installer (kubermatic-virtualization#149); `metallb.yaml` is the manual fallback.
- multus pods may CrashLoop on low memory; the optional helm upgrade in lab 04 redeploys the bundled `charts/multus-cni/` chart.
- The container image no longer preexports `$KUBECONFIG` (see "Training container" above); lab 04's README text hasn't been updated to match.

## Gitignore highlights

`bin/`, `charts/`, `*.tar.gz`, `**-linux-amd64**`, `*kubeconfig`, `kubeone_*`, `tf_infra`, `.secrets/`, `.DS_Store` are gitignored.

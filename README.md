# installer-immutable-sysext

> **WARNING: This project is under active development and is NOT ready for production use. APIs, configurations, and behavior may change without notice. Use at your own risk.**

> This repository is a **partial fork** of [flatcar/sysext-bakery](https://github.com/flatcar/sysext-bakery). Not all features from the original project are included, and significant modifications have been made to fit the needs of this project.

Build and publish systemd system extensions (`.raw` images) for **Kubernetes** and **Containerd** on immutable Linux distributions (e.g., Flatcar Container Linux).

Based on the [flatcar/sysext-bakery](https://github.com/flatcar/sysext-bakery) framework.

## Extensions

| Extension | Components |
|-----------|-----------|
| `kubernetes` | kubelet, kubeadm, kubectl, CNI plugins |
| `containerd` | containerd (static), runc |
| `etcd` | etcd |
| `kubeadm` | kubeadm configuration and setup |

## Usage

### List available extensions

```bash
./bakery.sh list
```

### List available versions

```bash
./bakery.sh list kubernetes
./bakery.sh list containerd
```

### Build a sysext image

```bash
# Kubernetes (latest patch of each supported minor)
./bakery.sh create kubernetes v1.32.0 --arch x86-64

# Containerd
./bakery.sh create containerd 2.0.0 --arch x86-64
```

### Build prerequisites (Linux)

```bash
sudo apt install curl jq squashfs-tools xz-utils erofs-utils
# yq is required for kubernetes version listing
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq
```

## CI/CD

The GitHub Actions workflow (`.github/workflows/release.yaml`) runs weekly (Mondays at 5am UTC) or on manual dispatch. It:

1. Checks `release_build_versions.txt` for versions to build
2. Resolves `latest` to actual version numbers
3. Builds both `x86-64` and `arm64` images for each version
4. Publishes GitHub Releases with `.raw` images, SHA256SUMS, and sysupdate configs

## Configuration

The `.env` file overrides the bakery defaults:

```bash
bakery="sighupio/installer-immutable-sysext"
bakery_hub=""
```

## Applying a sysext on a Flatcar node

```bash
# Download the .raw image
curl -LO https://github.com/sighupio/installer-immutable-sysext/releases/download/kubernetes-v1.32.0/kubernetes-v1.32.0-x86-64.raw

# Place it in the extensions directory
sudo cp kubernetes-v1.32.0-x86-64.raw /etc/extensions/kubernetes.raw

# Refresh system extensions
sudo systemd-sysext refresh
```

## License

Based on [flatcar/sysext-bakery](https://github.com/flatcar/sysext-bakery), licensed under the Apache 2.0 License.

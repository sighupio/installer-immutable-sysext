#!/usr/bin/env bash
# vim: et ts=2 syn=bash
#
# Kubeadm system extension.
#

RELOAD_SERVICES_ON_MERGE="true"

# --

# Return the latest patch of each supported Kubernetes release branch.
function list_latest_release() {
  curl -fsSL --retry-delay 1 --retry 60 --retry-connrefused \
       --retry-max-time 60 --connect-timeout 20 \
       https://raw.githubusercontent.com/kubernetes/website/main/data/releases/schedule.yaml \
       | yq -r '.schedules[] | .previousPatches[0] // (.release = .release + ".0") | .release' \
       | sed 's/^/v/'
}
# --

function list_available_versions() {
  curl -fsSL --retry-delay 1 --retry 60 --retry-connrefused \
       --retry-max-time 60 --connect-timeout 20 \
       https://raw.githubusercontent.com/kubernetes/website/main/data/releases/schedule.yaml \
       | yq -r '.schedules[] | .previousPatches[] // (.release = .release + ".0") | .release' \
       | sed 's/^/v/'
}
# --

function populate_sysext_root_options() {
  echo "  No additional options for kubeadm extension"
}
# --

function populate_sysext_root() {
  local sysextroot="$1"
  local arch="$2"
  local version="$3"

  local dl_arch="$(arch_transform "x86-64" "amd64" "$arch")"

  echo "Downloading kubeadm ${version} for ${dl_arch}..."

  mkdir -p "${sysextroot}/usr/bin"

  local kubeadmbin="${sysextroot}/usr/bin/kubeadm"
  curl -fsSL "https://dl.k8s.io/${version}/bin/linux/${dl_arch}/kubeadm" -o "${kubeadmbin}"
  chmod +x "${kubeadmbin}"

  echo "kubeadm binary installed to ${kubeadmbin}"
}
# --

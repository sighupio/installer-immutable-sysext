#!/usr/bin/env bash
# vim: et ts=2 syn=bash
#
# etcd system extension.
#

RELOAD_SERVICES_ON_MERGE="true"

# --

# Return the latest patch of each active major.minor branch (e.g. v3.5.x, v3.6.x).
# Only includes branches >= 3.5 (currently maintained by etcd upstream).
function list_latest_release() {
  list_github_releases "etcd-io" "etcd" \
    | sed -n 's/^v//p' \
    | awk -F. '$1 >= 3 && $2 >= 5 && !seen[$1"."$2]++ { print "v"$0 }'
}
# --

function list_available_versions() {
  list_github_releases "etcd-io" "etcd"
}
# --

function populate_sysext_root_options() {
  echo "  No additional options for etcd extension"
}
# --

function populate_sysext_root() {
  local sysextroot="$1"
  local arch="$2"
  local version="$3"

  local dl_arch="$(arch_transform "x86-64" "amd64" "$arch")"

  echo "Downloading etcd ${version} for ${dl_arch}..."

  local tarball="etcd-${version}-linux-${dl_arch}.tar.gz"
  local download_url="https://storage.googleapis.com/etcd/${version}/${tarball}"

  curl -fsSL "${download_url}" -o "${tarball}"
  tar --force-local -xzf "${tarball}"

  mkdir -p "${sysextroot}/usr/bin"
  cp "etcd-${version}-linux-${dl_arch}/etcd" "${sysextroot}/usr/bin/"
  cp "etcd-${version}-linux-${dl_arch}/etcdctl" "${sysextroot}/usr/bin/"
  cp "etcd-${version}-linux-${dl_arch}/etcdutl" "${sysextroot}/usr/bin/"
  chmod 755 "${sysextroot}/usr/bin/"*

  echo "etcd binaries installed to ${sysextroot}/usr/bin/"
}
# --

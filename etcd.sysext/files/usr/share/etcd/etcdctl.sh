#!/usr/bin/env bash
# etcdctl environment configuration
# This script sets up the environment variables needed to use etcdctl
#
# Usage:
#   source /usr/share/etcd/etcdctl.sh
#   etcdctl member list

export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/ssl/etcd/ca.crt
export ETCDCTL_CERT=/etc/ssl/etcd/apiserver-etcd-client.crt
export ETCDCTL_KEY=/etc/ssl/etcd/apiserver-etcd-client.key
export ETCDCTL_DIAL_TIMEOUT=3s
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379

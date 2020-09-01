#!/usr/bin/env sh

cat <<EOF | cfssl genkey - | cfssljson -bare ca
{
  "hosts": [
    "nginx",
    "nginx.argo",
    "nginx.argo.svc.cluster.local",
    "nginx.argo.pod.cluster.local"
  ],
  "CN": "nginx.argo.pod.cluster.local",
  "key": {
    "algo": "rsa",
    "size": 2048
  }
}
EOF
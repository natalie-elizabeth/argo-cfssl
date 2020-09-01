#!/bin/bash

# kctl environment

# kubectl create ns cfssl
kubectl create -f svc.yml -n argo

# create csr and key files

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

# create csr. CSR is not ns specific
cat <<EOF | kubectl apply  -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: nginx.argo
spec:
  request: $(cat ca.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# sign csr
kubectl certificate approve nginx.argo

# get cert file
kubectl get csr nginx.argo -n tls -o jsonpath='{.status.certificate}' | base64 --decode > server.crt

# create secret and cm
kubectl create secret tls nginxsecret -n argo --key ca-key.pem --cert server.crt
kubectl create cm nginxconfigmap --from-file=default.conf -n argo

kubectl create -f deploy.yml -n argo

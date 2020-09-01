
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

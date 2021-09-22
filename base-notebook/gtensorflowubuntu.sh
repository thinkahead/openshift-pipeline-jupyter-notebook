YOUR_NAMESPACE=madi
oc project $YOUR_NAMESPACE
echo Building
podman build --tls-verify=false --cap-add audit_write -t default-route-openshift-image-registry.apps.ies.pbm.ihost.com/$YOUR_NAMESPACE/base-notebook-tensorflowubuntu -f Dockerfile.ppc64le.tensorflowubuntu .
#podman build --squash-all --tls-verify=false -t default-route-openshift-image-registry.apps.ies.pbm.ihost.com/$YOUR_NAMESPACE/base-notebook-tensorflowubuntu -f Dockerfile.ppc64le.tensorflowubuntu .
echo Result=$?
echo Logging in to registry
podman login --tls-verify=false -u kubeadmin default-route-openshift-image-registry.apps.ies.pbm.ihost.com -p `cat oc_token` 2>&1 >/dev/null
if [ $? -ne 0 ]; then
  oc whoami -t > oc_token
  podman login --tls-verify=false -u kubeadmin default-route-openshift-image-registry.apps.ies.pbm.ihost.com -p `cat oc_token`
fi
echo Pushing
podman push --tls-verify=false default-route-openshift-image-registry.apps.ies.pbm.ihost.com/$YOUR_NAMESPACE/base-notebook-tensorflowubuntu

NETWORK_CIDR="172.16.0.0/12"
CALICO_VERSION="3.28.2"

kubeadm config images pull

kubeadm init --pod-network-cidr="${NETWORK_CIDR}" --ignore-preflight-errors=all >> /root/kubeinit.log 2>&1

mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

kubectl create --filename https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/tigera-operator.yaml
kubectl create --filename https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/custom-resources.yaml

cmd=$(kubeadm token create --print-join-command 2>/dev/null)
echo "$cmd --ignore-preflight-errors=all --v=5" > /tmp/cluster-connect.sh
chmod +x /tmp/cluster-connect.sh

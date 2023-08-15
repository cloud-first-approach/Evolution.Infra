kumactl install control-plane   --set "cni.enabled=true"   --set "cni.chained=true"   --set "cni.netDir=/etc/cni/net.d"   --set "cni.binDir=/opt/cni/bin"   --set "cni.confName=10-calico.conflist" --set "cni.enabled=true" --set "experimental.cni=true" | --set "experimental.ebpf.enabled=true" | kubectl apply -f .


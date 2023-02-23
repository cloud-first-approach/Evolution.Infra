
#^ INFRA SETUP

#? INSTALL PROMETHEUS

# helm search repo prometheus-community
kubectl create ns monitoring

kubectl apply --server-side -k .\Evolution.infra\deploy\k8s\infra\overlays\dev\

kubectl apply -k .\Evolution.uploader\deploy\k8s\uploader\overlays\dev\

kubectl apply -k .\Evolution.processor\deploy\k8s\processor\overlays\dev\

kubectl apply -k .\Evolution.uploader\deploy\k8s\uploader\overlays\dev\


# path for node exporter to work on windows, it deosnt work with docker in widnwosm but works with containerd
kubectl patch ds prometheus-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
     
# remove a namespace finalizer, requires jq package, ubuntu
NAMESPACE=uploader; kubectl get namespace $NAMESPACE -o json | jq 'del(.spec.fina
lizers[0])' | kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f -

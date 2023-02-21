
#^ INFRA SETUP

#? INSTALL PROMETHEUS

# helm search repo prometheus-community
kubectl create ns monitoring
# helm search repo prometheus-community
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm search repo prometheus-community
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
# path for node exporter to work on windows, it deosnt work with docker in widnwosm but works with containerd
kubectl patch ds prometheus-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
        

#^ APPS SETUP

# Mssql secret
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution
# AWS S3 Access secret
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY=$env:AWS_ACCESS_KEY -n evolution
# AWS S3 Access secret
kubectl create secret generic secret --from-literal=AWS_SECRET_KEY=$env:AWS_SECRET_KEY -n evolution

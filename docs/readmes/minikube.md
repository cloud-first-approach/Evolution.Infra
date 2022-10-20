
# Step 1


## Enable Hyper-V


https://minikube.sigs.k8s.io/docs/start/

```sh
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

minikube start --driver=hyperv 

minikube start --driver=docker

# To make hyperv the default driver:
minikube config set driver hyperv
minikube config set memory 2048

minikube profile list


#setup Kuma
kubectl apply -f .\Deploy\mesh\kuma.yaml



```


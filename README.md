# Evolution

The setup requires a secret file. private.secrets handy

The project tries to build a simple youtube backend for practice of Dev-Ops. Focusing both on Dev and Ops of a bit.

Few Building Blocks
- `IAC`
- `Cloud Native` using tools from CNCF
- Security
- Other Best Practices

The Project has few basic components

- `Uploader Api` to be able to upload videos
- `Processor Api` to process Videos and store
- `Streaming Api` to Stream Videos Directly and stored videos.
- `Client` on Blazor

# Infra Setup

## Prerequisites

- `Kubernetes`
- `kubectl`
- `docker`
- `dapr` cli


You can use kind to create a cluster or user docker to enable it.

```sh
# Check version (currently using 1.25)
kind version

# Create cluster
kind create cluster
```

# Setup dapr in kubernetes

```sh
dapr int -k
```

# Setup Secrets
```sh

#Setup Mssql server password to be used 
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution

#AWS S3 Access for ap to use
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY="AKIAYVIT7U44J******" -n evolution
kubectl create secret generic secret --from-literal=AWS_SECRET_KEY="Ib1GuABmPxOtDIEfeb7*****************" -n evolution

```

# Setup ArgoCD to deploy.

```sh

kubectl create namespace argocd

#intall from local folder
kubectl apply -n argocd -f deploy/k8s/argo/install.yaml


#intall latest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


#Argo UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

#Get Password for Argo
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

```
# Setup Project to Run

```sh
# login to you cluster
argocd login localhost:8080

argocd proj get evolution -o yaml

#Create Project
argocd proj create evolution -d https://kubernetes.default.svc,mynamespace -s https://github.com/cloud-first-approach/Evolution.infra.git

#Add Identity Service
argocd proj add-source evolution https://github.com/cloud-first-approach/Evolution.Identity.git

#Add more source repo for each services
argocd proj add-source evolution https://github.com/cloud-first-approach/Evolution.Uploader.git

#Add more source repo
argocd proj add-source evolution https://github.com/cloud-first-approach/Evolution.Processor.git

#incase of removal
argocd proj remove-source <PROJECT> <REPO>

```

# Evolution.infra

Manual instalation

```sh
# dev-infra
kubectl apply -k deploy/k8s/infra/overlays/dev

# prod-infra
kubectl apply -k deploy/k8s/infra/overlays/prod

```
Delpoy using Argo cd

```sh
# Start Dev Environment
argocd app create evo-dev-infra --repo https://github.com/cloud-first-approach/Evolution.infra.git --path deploy/k8s/infra/overlays/dev --dest-server https://kubernetes.default.svc --dest-namespace evolution

# Start Prod Environment
argocd app create evo-prod-infra --repo https://github.com/cloud-first-approach/Evolution.infra.git --path deploy/k8s/infra/overlays/prod --dest-server https://kubernetes.default.svc --dest-namespace evolution

```
# Evolution.Identity

```sh
#Manual instalation

kubectl apply -k deploy/k8s/services

#ArgoCD

argocd app create evo-identity-app --repo https://github.com/cloud-first-approach/Evolution.Identity.git --path deploy/k8s/services --dest-server https://kubernetes.default.svc --dest-namespace evolution

argocd app sync evo-identity-app

```

# Evolution.Uploader

```sh
#Manual instalation

kubectl apply -k deploy/k8s/services

#ArgoCD
argocd app create evo-uploader-app --repo https://github.com/cloud-first-approach/Evolution.Uploader.git --path deploy/k8s/services --dest-server https://kubernetes.default.svc --dest-namespace evolution

argocd app sync evo-uploader-app

```

# Evolution.Processor

```sh
#Manual instalation

kubectl apply -k deploy/k8s/services

#ArgoCD
argocd app create evo-processor-app --repo https://github.com/cloud-first-approach/Evolution.Uploader.git --path deploy/k8s/services --dest-server https://kubernetes.default.svc --dest-namespace evolution

argocd app sync evo-processor-app
```
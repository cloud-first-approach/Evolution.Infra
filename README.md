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
dapr init -k
```

# Setup Redis

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install redis bitnami/redis --set image.tag=6.2

# get dynamically genrated password
kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 -d

# || OR

# if redis/charts folder not there one time activity
kubectl kustomize .\deploy\k8s\infra\base\redis\charts\redis\ --enable-helm

#change the values.yaml passwrord:password@1

helm install redis .\deploy\k8s\infra\base\redis\charts\redis\ 
#redis password for all / dapr components : password@1
#redis url for all / dapr components : redis-master.default.svc.cluster.local:6379
```


# Create a namespace (evolution)

```sh
kubectl create ns evolution
```


# Setup Secrets
```sh

#Setup Mssql server password to be used 
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution

#AWS S3 Access for app to use
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY="AKIAYVIT7U44J******" -n evolution
kubectl create secret generic secret --from-literal=AWS_SECRET_KEY="Ib1GuABmPxOtDIEfeb7*****************" -n evolution

```

# Setup ArgoCD to deploy.

```sh
kubectl create namespace argocd

#intall from local folder
kubectl apply -n argocd -f deploy/k8s/argo/install.yaml

#Argo UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

#Get Password for Argo
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

```
# Setup Project to Run

```sh
# login to you cluster beore any command, username : admin
argocd login localhost:8080

argocd proj get evolution -o yaml

#Create Project
argocd proj create evolution -d https://kubernetes.default.svc,evolution -s https://github.com/cloud-first-approach/Evolution.infra.git
argocd proj delete evolution

argocd proj allow-cluster-resource evolution * *
argocd proj add-destination evolution https://kubernetes.default.svc,evolution
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
# Start Dev Environment and sync
argocd app create evo-dev-infra --repo https://github.com/cloud-first-approach/Evolution.infra.git --path deploy/k8s/infra/overlays/dev --dest-server https://kubernetes.default.svc --dest-namespace evolution
#now sync
argocd app sync evo-dev-infra
#delete
argocd app delete evo-dev-infra

# Start Prod Environment and sync
argocd app create evo-prod-infra --repo https://github.com/cloud-first-approach/Evolution.infra.git --path deploy/k8s/infra/overlays/prod --dest-server https://kubernetes.default.svc --dest-namespace evolution

argocd app sync evo-prod-infra

```
# Evolution.Identity

```sh
#Manual instalation

# Includes dapr annotations
kubectl apply -k deploy/k8s/identity/overlays/dev

#ArgoCD

argocd app create evo-identity-app --repo https://github.com/cloud-first-approach/Evolution.Identity.git --path deploy/k8s/identity/overlays/dev --dest-server https://kubernetes.default.svc --dest-namespace evolution

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

---

# More Info on redis setup

Redis&reg; can be accessed on the following DNS names from within your cluster:

    redis-master.default.svc.cluster.local for read/write operations (port 6379)
    redis-replicas.default.svc.cluster.local for read-only operations (port 6379)



To get your password run:

    export REDIS_PASSWORD=$(kubectl get secret --namespace default redis -o jsonpath="{.data.redis-password}" | base64 -d)

To connect to your Redis&reg; server:

1. Run a Redis&reg; pod that you can use as a client:

```sh
   kubectl run --namespace default redis-client --restart='Never'  --env REDIS_PASSWORD=$REDIS_PASSWORD  --image docker.io/bitnami/redis:6.2 --command -- leep #infinity
```
   Use the following command to attach to the pod:

```sh
   kubectl exec --tty -i redis-client \
   --namespace default -- bash
```
2. Connect using the Redis&reg; CLI:

```sh
   REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis-master
   REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h redis-replicas
```
To connect to your database from outside the cluster execute the following commands:
    
    ```sh
    kubectl port-forward --namespace default svc/redis-master 6379:6379 &
    REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h 127.0.0.1 -p 6379
    ```
WARNING: Rolling tag detected (bitnami/redis:6.2), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/




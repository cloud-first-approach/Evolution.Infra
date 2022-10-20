# Evolution
### Cloud first approach for building applications


![alt text](https://github.com/cloud-first-approach/Evolution.infra/blob/main/docs/images/frontpage.png)

# Role and Responsibility of Dev Ops

We would be taking a look at deploying the code to multiple infra.


![alt text](https://github.com/cloud-first-approach/Evolution.infra/blob/main/docs/images/Ingraphics-devops.png)


# Features and Scope of Project

Evolution is a cloud-enabled, devops-ready practice for any applications, built to be deployed on kubernetes.

- Microservices using Clean Architecture
- Async Communication using Message Queue
- GRPC Communication
- Infrastructure as code
- Service Mesh (Kuma/Istio)
- Container (Podman/docker)
- Terraform

# Prerequisites

To successfully run the app you need to have the followings setup correctly.

- [.NET Core](https://dotnet.microsoft.com/) - Free. Cross-platform. Open source.
A developer platform for building all your apps!
- [ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/?view=aspnetcore-6.0) - ASP.NET Core to create web apps and services that are fast, secure, cross-platform, and cloud-based
- [Docker](https://www.docker.com/) - OS-level virtualization to deliver software in packages called containers.
- [Redis](https://redis.io/) - The open source, in-memory data store used by millions of developers as a database, cache, streaming engine, and message broker.
- [RabbitMQ](https://www.rabbitmq.com/) - RabbitMQ is one of the most popular open source message brokers.
- [Kubernetes](https://kubernetes.io/) - Kubernetes is an open-source container orchestration system for automating software deployment, scaling, and management. (kind / minikube / EKS / AKS). Kubectl also is required to be setup.
- [Terraform](https://www.terraform.io/) - Terraform is an open-source infrastructure as code software tool created by HashiCorp.
- [Dapr](https://www.terraform.io/) - Terraform is an open-source infrastructure as code software tool created by HashiCorp. Get [Microsoft Learning Ebook](https://learn.microsoft.com/en-us/dotnet/architecture/dapr-for-net-developers/)

 - **Learn how to spin up your own cluster** [Click here](https://github.com/iamsourabh-in/Evolution/tree/master/Deploy/readme.md) 


# Project Overview

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

# Deployment


## Setup dapr in kubernetes

```sh
dapr init -k
```

## Setup Redis

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

helm uninstall redis



### working with redis :



rdcli -h <host>(localhost) -a  -p 6379

redis-cli -p 6379 

MSET orderId1 "101||1" orderId2 "102||1"

```
Using the [Redis CLI](https://redis.com/blog/get-redis-cli-without-installing-redis-server/), connect to the Redis instance:

## Create a namespace (evolution)

```sh
kubectl create ns evolution

kubectl create ns monitoring
```


## Setup Secrets
```sh

#Setup Mssql server password to be used 
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution

#AWS S3 Access for app to use
kubectl create secret generic access --from-literal=AWS_ACCESS_KEY="AKIAYVIT7U44J******" -n evolution

kubectl create secret generic secret --from-literal=AWS_SECRET_KEY="Ib1GuABmPxOtDIEfeb7*****************" -n evolution

```
# Continuous Delivery

You can deploy and use `Argo CD` or `Flux` for Continuous Delivery


## Setup Argo CD to deploy.

```sh
kubectl create namespace argocd

#intall from local folder
kubectl apply -n argocd -f deploy/k8s/argo/install.yaml

#Argo UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

#Get Password for Argo
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

```
## Setup Project to Run using Argo CD

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

## Setup Flux

```sh

kubectl create ns flux-system

SET GITHUB_USER=cloud-first-approach

flux bootstrap github --owner=%GITHUB_USER% --repository=Evolution.infra --branch=main --path=./deploy/k8s/flux/clusters/dev --personal
# with access Token required from github

flux reconcile kustomization webapp-dev --with-source

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
kubectl apply -k Evolution.Identity/deploy/k8s/identity/overlays/dev

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



# flagger:

```sh

helm upgrade -i ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --set controller.metrics.enabled=true --set controller.podAnnotations."prometheus\.io/scrape"=true --set controller.podAnnotations."prometheus\.io/port"=10254


helm upgrade -i flagger flagger/flagger --namespace ingress-nginx --set prometheus.install=true --set meshProvider=nginx

```

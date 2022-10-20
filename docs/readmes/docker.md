


# Step 1


**Build Projects**



```sh

docker build -t rohitrustagi007/platformservice .

docker push rohitrustagi007/platformservice

docker build -t rohitrustagi007/commandservice .

docker push rohitrustagi007/commandservice

```
# Kubenetes


**Deployments**

```sh
kubectl apply -f Deploy/K8S/platform-depl.yaml

kubectl delete deploy platforms-depl 

kubectl delete service platform-cluster-ip

kubectl apply -f Deploy/K8S/command-depl.yaml

kubectl delete deploy command-depl 

kubectl delete service command-cluster-ip

```

**Ingress**

```sh

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml

 kubectl apply -f .\Deploy\K8s\ingress\ingress-nginx-srv.yaml

kubectl delete ingress ingress-nginx-srv 

```

**Persistance volume claims**
```sh

kubectl apply -f .\Deploy\K8s\local-pvc.yaml

kubectl delete pvc sqlserver-pvc

```

**Secrets**
```sh
kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1"
```


**MSSQL Server Express** 
```sh
kubectl apply -f .\Deploy\K8s\mssql-depl.yaml

kubectl delete deploy mssql-depl

kubectl delete service mssql-loadbalancer

kubectl delete service mssql-cluster-ip

```


# Redis
```sh
kubectl apply -f ./Deploy/K8S/redis/redis-config.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/pods/config/redis-pod.yaml
OR
kubectl apply -f ./Deploy/K8S/redis/redis-pod.yaml

kubectl get pod/redis configmap/redis-config 

kubectl describe configmap/redis-config

### Further Configurations

kubectl exec -it redis -- redis-cli

127.0.0.1:6379> CONFIG GET maxmemory

127.0.0.1:6379> CONFIG GET maxmemory-policy

```

# Helpers

```sh
kubectl describe pod platforms-depl-85c65658cd-44zc8  

docker info

kubectl get services

kubectl get pvc  -o wide

kubectl get pods

kubectl get namespaces
```

## Tools
```sh

kubectl apply -f  https://raw.githubusercontent.com/spekt8/spekt8/master/spekt8-deployment.yaml
kubectl apply -f https://raw.githubusercontent.com/spekt8/spekt8/master/fabric8-rbac.yaml
kubectl port-forward deployment/spekt8 3000:3000

OR LOCAL BELOW

kubectl apply -f .\Deploy\K8s\spectk8.yaml
kubectl apply -f .\Deploy\K8s\admin.yaml 
kubectl port-forward deployment/spekt8 3000:3000
```

## Others
```sh
kubectl config view

kubectl get pods -n kube-system

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

kubectl apply -f ./Deploy/K8S/setup/service-account.yaml

kubectl apply -f ./Deploy/K8S/setup/role-binding.yaml   

#- gennerate token from belo command

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/sourabhr -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```
## Terraform
```sh
terraform plan

terraform apply

terraform apply -target=aws_security_group.my_sg

terraform destroy
```
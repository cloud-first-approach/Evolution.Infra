terrform plan

aws eks update-kubeconfig --region ap-south-1 --name eks-demo --profile "Yahoo Free"

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

helm repo add eks https://aws.github.io/eks-charts
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json


eksctl create iamserviceaccount --region ap-south-1 --cluster=eks-demo --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::164133371383:policy/AWSLoadBalancerController --profile "Yahoo Free" --approve

# If using IAM Roles for service account install as follows -  NOTE: you need to specify both of the chart values `serviceAccount.create=false` and `serviceAccount.name=aws-load-balancer-controller`
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=eks-demo -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

# If not using IAM Roles for service account (Not Required)
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=my-cluster -n kube-system

kubectl apply -k .\Evolution.uploader\deploy\k8s\uploader\overlays\dev\

kubectl run mycurlpod --image=curlimages/curl

kubectl apply -f .\Evolution.infra\deploy\k8s\buzybox.yaml

kubectl apply -f .\Evolution.infra\deploy\k8s\dnsutils.yaml

kubectl apply -f .\Evolution.infra\deploy\k8s\curl.yaml

kubectl exec -i -t dnsutils -- nslookup kubernetes.default

kubectl exec -i -t dnsutils -- nslookup uploader-api.uploader.svc.cluster.local

kubectl exec -i -t mycurlpod -- sh

curl uploader-api.uploader.svc.cluster.local/uploads/test -v 


curl uploader-api-gateway.uploader.svc.cluster.local/uploads/test -v 

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

terrform plan

aws eks update-kubeconfig --region ap-south-1 --name eks-demo --profile "Yahoo Free"

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

helm repo add eks https://aws.github.io/eks-charts
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json


eksctl create iamserviceaccount --cluster=eks-demo --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::164133371383:policy/AWSLoadBalancerController --approve

# If using IAM Roles for service account install as follows -  NOTE: you need to specify both of the chart values `serviceAccount.create=false` and `serviceAccount.name=aws-load-balancer-controller`
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=eks-demo -n kube-system --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

# If not using IAM Roles for service account
helm install aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=my-cluster -n kube-system



kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

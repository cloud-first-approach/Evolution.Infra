#? The script tries to deploy the resource to K8, via kubectl or flux.
#! Mandatory Parameters : $mode, $env
#*--------------------------------------------------------------------------------
#? Example 
   #! Just pre configure the Cluster with few prerequistes like, prom-op,redis
   #? ./deploy.ps1 -mode local -env dev -preonly true
   #! Deploys the complete infra and services
   #? ./deploy.ps1 -mode local -env dev -preonly false 
#*--------------------------------------------------------------------------------
param( [Parameter(Mandatory = $true)] $mode = "local", [Parameter(Mandatory = $true)] $env = "dev", $preonly = "false", $skippre = "false")

#& Create namespace 'evolution' and adding secrets
$namespace = kubectl get ns evolution --output=json | ConvertFrom-Json
if ($namespace.metadata.name -ne "evolution") {
    kubectl create ns evolution
}
else {
    Write-Output "evolution namespace already exists"
}

#& Setting Up Secrets from env 

if ($null -eq $env:AWS_ACCESS_KEY -and $null -eq $env:AWS_SECRET_KEY ) {
    Write-Output "Environment variables are required. AWS_ACCESS_KEY or AWS_SECRET_KEY is not present"
    exit 1
}
else {
    # Mssql secret
    kubectl create secret generic mssql --from-literal=SA_PASSWORD="password@1" -n evolution
    # AWS S3 Access secret
    kubectl create secret generic access --from-literal=AWS_ACCESS_KEY=$env:AWS_ACCESS_KEY -n evolution
    # AWS S3 Access secret
    kubectl create secret generic secret --from-literal=AWS_SECRET_KEY=$env:AWS_SECRET_KEY -n evolution
}

$namespace = kubectl get ns dapr-system --output=json | ConvertFrom-Json
if ($namespace.metadata.name -ne "dapr-system") {
    dapr init -k
    Start-sleep -s 2
}
else {
    Write-Output "dapr-system already ready"
}


#&  Setup Prometheus Operator
$helm = helm list --output=json | ConvertFrom-Json 
$relases = @($helm.name)
if (!$relases.Contains('prometheus')) {
    kubectl create ns monitoring
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    #helm search repo prometheus-community
    helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
    kubectl patch ds prometheus-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
    #! grafana pass : prom-operator, user: admin

}
Start-sleep -s 1

#& Enable dapr
$namespace = kubectl get ns dapr-system --output=json | ConvertFrom-Json
if ($namespace.metadata.name -ne "dapr-system") {
    dapr init -k
    Start-sleep -s 1
}
else {
    Write-Host "dapr-system already ready"  -Foregroundcolor Green
}


#&  Setup Redis and Vault 
$helm = helm list --output=json | ConvertFrom-Json 
$relases = @($helm.name)
if (!$relases.Contains('redis')) {
    helm install redis .\Evolution.infra\deploy\k8s\infra\base\redis\charts\redis\ 
}
if (!$relases.Contains('vault')) {
    helm repo add hashicorp https://helm.releases.hashicorp.com
    helm install vault hashicorp/vault
}
Start-sleep -s 1

#& If Pre only , EXIT from here.
if ($preonly -eq "true") {
    Write-Output "Cluster Pre configuration done. Deploy infra and services manually."
    exit 1
}

#? Cheking mode to deploy, If local would deploy directly
If ($mode -eq "local") {   

    #& Setup Infra
    $sql = kubectl get deploy mssql-server -n evolution --output=json | ConvertFrom-Json
    if ($sql.metadata.name -ne "mssql-server") {
        kubectl apply -k .\Evolution.infra\deploy\k8s\infra\overlays\$env
        Start-sleep -s 10
    }
    else {
        Write-Output "infra setup already done, sql ready"
    }
   
    #& Setup Identity API  
    $identity = kubectl get deploy identity-api-deployment -n evolution --output=json | ConvertFrom-Json
    if ($identity.metadata.name -ne "identity-api-deployment") {
        kubectl apply -k .\Evolution.Identity\deploy\k8s\identity\overlays\$env
        Start-sleep -s 2
    }
    else {
        Write-Host "Identity Api already running"  -Foregroundcolor Green
    }
        
    #& Setup Processor API
    $processor = kubectl get deploy processor-api-deployment -n evolution --output=json | ConvertFrom-Json
    if ($processor.metadata.name -ne "processor-api-deployment") {
        kubectl apply -k .\Evolution.Processor\deploy\k8s\processor\overlays\$env
        Start-sleep -s 2
    }
    else {
        Write-Host "Processor Api already running" -Foregroundcolor Green
    }
    
    #& Setup Uploader API
    $uploader = kubectl get deploy uploader-api-deployment -n evolution --output=json | ConvertFrom-Json
    if ($uploader.metadata.name -ne "uploader-api-deployment") {
        kubectl apply -k .\Evolution.Uploader\deploy\k8s\uploader\overlays\$env
    }
    else {
        Write-Host "Uploader Api already running" -Foregroundcolor Green
    }

    Write-Host "Successfully deployed all resources in $env" -Foregroundcolor Green
}
elseif ($mode -eq "flux") {

    Set-Location Evolution.infra
   
    $GITHUB_USER = 'cloud-first-approach'
    flux bootstrap github --owner=$GITHUB_USER --repository=Evolution.infra --branch=main --path=./deploy/k8s/flux/clusters/$env --personal

}


# $helm | Where-Object -FilterScript { $Output.name -match 'evolution' }  |
#   ForEach-Object -Process { 
#     echo $Output.name
#   }
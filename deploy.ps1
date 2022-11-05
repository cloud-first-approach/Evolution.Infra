#? The script tries to deploy the resource to K8, via kubectl or flux.
#! Mandatory Parameters : $mode, $env
#*--------------------------------------------------------------------------------
#? Example 
   #! Just pre configure the Cluster with few prerequistes like, prom-op,redis
   #? ./deploy.ps1 -mode local -env dev -preSetup true -deploy true
   #! Deploys the complete infra and services
   #? ./deploy.ps1 -mode local -env dev -preSetup false -deploy true
#*--------------------------------------------------------------------------------
param( [Parameter(Mandatory = $true)] $mode = "local", [Parameter(Mandatory = $true)] $env = "dev", $preSetup = "false", $deploy = "false")


#-------- Functions-----------------------------
function CreateNamespaceInK8 {
    param (
        $name
    )
    $namespace = kubectl get ns $name --output=json | ConvertFrom-Json
    if ($namespace.metadata.name -ne $name) {
        kubectl create ns $name
    }
    else {
        Write-Output "$name namespace already exists"
    }
}

function InstallDaprInK8 {
    dapr init -k
    Start-sleep -s 2
}
#-------- Functions-----------------------------



##  ----------------- > Pre Configure K8 Cluster with Dapr, Redis, Secrets, Vault and Prometheus <---------------
#& Setup
if ($preSetup -eq "true") {
    #& Create namespace 'evolution' and adding secrets
    CreateNamespaceInK8 -name evolution

    #& Enable dapr
    InstallDaprInK8

    $namespace = kubectl get ns kubernetes-dashboard --output=json | ConvertFrom-Json 
    if ($namespace.metadata.name -ne "kubernetes-dashboard") {
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
    }
    else {
        Write-Output "kubernetes-dashboard already exists. Doing Nothing !!" -Foregroundcolor Red
    }
    
    #& Create deployment 'evolution'
    kubectl create deployment zipkin --image openzipkin/zipkin -n evolution

    
   



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


    #&  Setup Redis and Vault and Prometheus Operator
    $helm = helm list -A --output=json | ConvertFrom-Json 
    $relases = @($helm.name)
    if (!$relases.Contains('redis')) {
        helm install redis .\Evolution.infra\deploy\k8s\infra\base\redis\charts\redis\ 
    }
    if (!$relases.Contains('vault')) {
        helm repo add hashicorp https://helm.releases.hashicorp.com
        helm install vault hashicorp/vault
    }
    if (!$relases.Contains('prometheus')) {
        kubectl create ns monitoring
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        #helm search repo prometheus-community
        helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
        kubectl patch ds prometheus-prometheus-node-exporter --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]' -n monitoring
        #! grafana pass : prom-operator, user: admin
    }
    if (!$relases.Contains('linkerd')) {
        helm repo add linkerd https://helm.linkerd.io/stable
        
        helm install linkerd-crds linkerd/linkerd-crds -n linkerd --create-namespace 

        #~ STEP to GENERATE CERT FOR LINKERD
        #* **** curl.exe -LO https://dl.step.sm/gh-release/cli/docs-cli-install/v0.21.0/step_windows_0.21.0_amd64.zip
        #* *** Download Step and add bin/step.exe to path. Then, run below connands
        #* step certificate create root.linkerd.cluster.local ca.crt ca.key --profile root-ca --no-password --insecure
        #* step certificate create identity.linkerd.cluster.local issuer.crt issuer.key --profile intermediate-ca --not-after 8760h --no-password --insecure --ca ca.crt --ca-key ca.key


        helm install linkerd-control-plane -n linkerd --set-file identityTrustAnchorsPEM=ca.crt --set-file identity.issuer.tls.crtPEM=issuer.crt --set-file identity.issuer.tls.keyPEM=issuer.key linkerd/linkerd-control-plane

    }
   
    Start-sleep -s 2

    #& If Pre only , EXIT from here.
  
}

#& Deploy
if($deploy -eq "true"){
    #? Cheking mode to local, If local would deploy directly
    If ($mode -eq "local") {   
        
        Write-Output "Deploying Indivisual repo locally using kubectl"
    
        $sql = kubectl get deploy mssql-server -n evolution --output=json | ConvertFrom-Json
        if ($sql.metadata.name -ne "mssql-server") {
            kubectl apply -k .\Evolution.infra\deploy\k8s\infra\overlays\$env
            Start-sleep -s 30
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

        $token = kubectl -n kubernetes-dashboard create token admin-user

        Write-Host "$token" -Foregroundcolor Green

    }
    elseif ($mode -eq "flux") {

        Set-Location Evolution.infra
    
        $GITHUB_USER = 'cloud-first-approach'
        flux bootstrap github --owner=$GITHUB_USER --repository=Evolution.infra --branch=main --path=./deploy/k8s/flux/clusters/$env --personal

    }
    else{
        Write-Output "Invalid 'mode' selected" 
    }
}


# $helm | Where-Object -FilterScript { $Output.name -match 'evolution' }  |
#   ForEach-Object -Process { 
#     echo $Output.name
#   }

param( [Parameter(Mandatory = $true)] $mode, [Parameter(Mandatory = $true)] $env)

function Error {
    param (
        $msg
    )
    Write-Host "$msg" -Foregroundcolor Red
}

If ($mode -eq "local") {
    Error -msg "Destroying Processor" 
    kubectl delete -k .\Evolution.Processor\deploy\k8s\processor\overlays\$env
    Error -msg "Destroying Uploader" 
    kubectl delete -k .\Evolution.Uploader\deploy\k8s\uploader\overlays\$env
    Error -msg "Destroying Identity"
    kubectl delete -k .\Evolution.Identity\deploy\k8s\identity\overlays\$env
    Error -msg "Destroying infra"
    kubectl delete -k .\Evolution.infra\deploy\k8s\infra\overlays\$env
    Error -msg "Removing vault"
    helm uninstall vault
    Error -msg "removing dapr from k8" 
    dapr uninstall -k
    Write-Host "removing redis" -Foregroundcolor Red
    helm uninstall redis 
    Write-Host "removing prometheus" -Foregroundcolor Red
    helm uninstall prometheus -n monitoring
    Write-Host "removing dahboard" -Foregroundcolor Red
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml
    Write-Host "removing zipkin" -Foregroundcolor Red
    kubectl delete deployment zipkin -n evolution

    #others ns clearance
    kubectl delete  ns monitoring 
    kubectl delete  ns dapr-system 
    kubectl delete  ns evolution 
    kubectl delete  ns kubernetes-dashboard 

    Write-Host "removing linkerd" -Foregroundcolor Red
    helm uninstall linkerd-control-plane -n linkerd
    
    Write-Host "removing linkerd crds" -Foregroundcolor Red
    helm uninstall linkerd-crds -n linkerd
}
elseif ($mode -eq "flux") {
    Write-Host "Destroying Identity kustomization"
    kubectl delete kustomization identity-api -n evolution
    Write-Host "Destroying Uploader kustomization"
    kubectl delete kustomization uploader-api -n evolution
    Write-Host "Destroying Processor kustomization"
    kubectl delete kustomization processor-api -n evolution
    Write-Host "Destroying infra kustomization"
    kubectl delete kustomization infra -n evolution
    Write-Host "Destroying flux-system"
    flux uninstall flux-system
    Write-Host "Destroying redis"
    helm uninstall redis
    Write-Host "Destroying vault"
    helm uninstall vault
    Write-Host "Destroying dapr"
    dapr uninstall -k
}
Write-Host "Successfully removed all resources" -Foregroundcolor Green

param( [Parameter(Mandatory = $true)] $mode, [Parameter(Mandatory = $true)] $env)
If ($mode -eq "local") {
    Write-Output "Destroying Processor"
    kubectl delete -k .\Evolution.Processor\deploy\k8s\processor\overlays\$env
    Write-Output "Destroying Uploader"
    kubectl delete -k .\Evolution.Uploader\deploy\k8s\uploader\overlays\$env
    Write-Output "Destroying Identity"
    kubectl delete -k .\Evolution.Identity\deploy\k8s\identity\overlays\$env
    Write-Output "Destroying infra"
    kubectl delete -k .\Evolution.infra\deploy\k8s\infra\overlays\$env
    Write-Output "Destroying vault"
    helm uninstall vault
    Write-Output "removing dapr from k8"
    dapr uninstall -k
    Write-Output "removing redis"
    helm uninstall redis 
    Write-Output "removing prometheus" 
    helm uninstall prometheus -n monitoring
    #others ns clearance
    kubectl delete  ns monitoring 
    kubectl delete  ns dapr-system 
    kubectl delete  ns evolution 

    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml

}
elseif ($mode -eq "flux") {
    Write-Output "Destroying Identity kustomization"
    kubectl delete kustomization identity-api -n evolution
    Write-Output "Destroying Uploader kustomization"
    kubectl delete kustomization uploader-api -n evolution
    Write-Output "Destroying Processor kustomization"
    kubectl delete kustomization processor-api -n evolution
    Write-Output "Destroying infra kustomization"
    kubectl delete kustomization infra -n evolution
    Write-Output "Destroying flux-system"
    flux uninstall flux-system
    Write-Output "Destroying redis"
    helm uninstall redis
    Write-Output "Destroying vault"
    helm uninstall vault
    Write-Output "Destroying dapr"
    dapr uninstall -k
}
Write-Host "Successfully removed all resources" -Foregroundcolor Green
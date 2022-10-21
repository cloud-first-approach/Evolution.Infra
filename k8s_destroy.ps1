
param( [Parameter(Mandatory=$true)] $env,$includeDapr)
If ($env -eq "k8s") {

    kubectl delete -k .\Evolution.Processor\deploy\k8s\processor\overlays\dev

    kubectl delete -k .\Evolution.Uploader\deploy\k8s\uploader\overlays\dev

    kubectl delete -k .\Evolution.Identity\deploy\k8s\identity\overlays\dev

    kubectl delete -k .\Evolution.infra\deploy\k8s\infra\overlays\dev


}
elseif ($env -eq "flux") {

    kubectl delete kustomization identity-api -n evolution

    kubectl delete kustomization uploader-api -n evolution

    kubectl delete kustomization processor-api -n evolution

    kubectl delete kustomization infra -n evolution

    flux uninstall flux-system
}

If($includeDapr -eq "true")
{
    helm uninstall redis

    dapr uninstall -k
   
}
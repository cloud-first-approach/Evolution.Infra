
# Flux & fluxctl

```sh
kubectl create ns flux-system

SET GITHUB_USER=iamsourabh-in


SET GITHUB_USER=cloud-first-approach

flux bootstrap github --owner=%GITHUB_USER% --repository=Evolution.infra --branch=main --path=./deploy/K8s/clusters/dev --personal


#setup Flux in K8 for pulling you repo for sync
fluxctl install --git-user=iamsourabh-in --git-email=iamsourabh-in@users.noreply.github.com --git-url=git@github.com:iamsourabh-in/Evolution --git-path=deploy/K8s/infra/overlays/dev --git-branch=flux --namespace=flux-system | kubectl apply -f -

kubectl -n flux-system rollout status deployment/flux

fluxctl list-workloads --k8s-fwd-ns flux-system

fluxctl identity --k8s-fwd-ns flux-system


https://github.com/marcel-dempers/docker-development-youtube-series/settings/keys/new

fluxctl sync --k8s-fwd-ns flux-system

  annotations:
    fluxcd.io/tag.example-app: semver:~1.0
    fluxcd.io/automated: 'true'

fluxctl policy -w default:deployment/example-deploy --tag "example-app=1.0.*"

```

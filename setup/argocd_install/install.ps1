##2024030 v2.10.8
#https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/
#https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

$installpath = "C:/code/fnietoga/crossplane-poc/setup/argocd_install"
helm upgrade --install argocd `
--namespace argocd `
--create-namespace `
-f $installpath/values.yaml `
argo/argo-cd

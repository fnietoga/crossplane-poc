##20240429 - v1.15.2
##https://docs.crossplane.io/latest/software/install/

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

$installpath = "C:/code/fnietoga/crossplane-poc/setup/crossplane_install"
helm upgrade --install crossplane `
--namespace crossplane-system `
--create-namespace `
-f $installpath/values.yaml `
crossplane-stable/crossplane

$rootpath = "C:/code/fnietoga/crossplane-poc/azure"
kubectl apply -f $rootpath/providers/0.ServiceAccount.yaml
kubectl apply -f $rootpath/providers/1.DeploymentRuntimeConfig_enable-ess.yaml
kubectl apply -f $rootpath/providers/family-azure.yaml
kubectl apply -f $rootpath/providers/azure-management.yaml
kubectl apply -f $rootpath/providers/azure-storage.yaml
kubectl apply -f $rootpath/providers/azure-keyvault.yaml



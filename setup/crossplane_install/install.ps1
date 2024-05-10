##20240429 - v1.15.2
##https://docs.crossplane.io/latest/software/install/

helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm upgrade --install crossplane `
--namespace crossplane-system `
--create-namespace `
-f C:\code\fnietoga\crossplane\crossplane_install\values.yaml `
crossplane-stable/crossplane

kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\providers\0.DeploymentRuntimeConfig_enable-ess.yaml
kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\providers\family-azure.yaml
kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\providers\azure-management.yaml
kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\providers\azure-storage.yaml
kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\providers\azure-keyvault.yaml

kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\testapp01\testapp01_config.yaml
kubectl apply -f C:\code\fnietoga\crossplane\crossplane_install\azure\testapp02\testapp02_config.yaml
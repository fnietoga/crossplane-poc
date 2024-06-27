$resourceGroupName="RSG-WE-D-AKS-01"
$location="uksouth"
$aksClusterName="aks-we-d-tests-01"

az login --tenant $Env:FNIETOGA_TENANT_ID --use-device-code
az account set --subscription $Env:FNIETOGA_SUBSCRIPTION_ID
az group create --name $resourceGroupName --location $location
az aks create --resource-group $resourceGroupName --name $aksClusterName `
    --tier free --kubernetes-version '1.29.4' --enable-aad --enable-azure-rbac `
    --auto-upgrade-channel 'patch' --node-os-upgrade-channel 'NodeImage'  `
    --node-count 1 --nodepool-name 'agentpool' --node-vm-size 'Standard_D4ds_v5' --os-sku 'Ubuntu' --node-provisioning-mode 'Manual' --max-pods 150 `
    --network-plugin 'azure' --dns-name-prefix "$aksClusterName-dns" --network-policy 'calico' --load-balancer-sku 'standard' `
    --node-resource-group "$resourceGroupName-NODES" `
    --generate-ssh-keys --enable-azure-monitor-metrics --enable-oidc-issuer

az role assignment create --scope "/subscriptions/$Env:FNIETOGA_SUBSCRIPTION_ID/resourceGroups/$resourceGroupName/providers/Microsoft.ContainerService/managedClusters/$aksClusterName" --role "Azure Kubernetes Service RBAC Cluster Admin" --assignee-object-id "5f4d2ac3-5f9a-42fb-9e0b-d71b8b3bdee1"  --assignee-principal-type User
az aks get-credentials --resource-group $resourceGroupName --name $aksClusterName --overwrite-existing --file "$env:USERPROFILE\.kube\fnieto_config"
kubectl config use-context $aksClusterName
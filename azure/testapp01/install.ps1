az login --tenant $Env:FNIETOGA_TENANT_ID --use-device-code
az account set --subscription $Env:FNIETOGA_SUBSCRIPTION_ID

$aksResourceGroupName = "RG-WE-D-AKS-01"
$aksClusterName = "aks-we-d-tests-01"
$clusterIssuer=$(az aks show --resource-group $aksResourceGroupName --name $aksClusterName --query "oidcIssuerProfile.issuerUrl" -o tsv)

$resourceGroupName01 = "RG-WE-D-TESTAPP-01"
$location="uksouth"
$identityName01 = "umi-we-d-testapp-01"
az group create --name $resourceGroupName01 --location $location
az identity create --name $identityName01 --resource-group $resourceGroupName01
$identityClientId01=$(az identity show --name $identityName01 -g $resourceGroupName01 --query 'clientId' -o tsv)
az role assignment create `
    --role "Owner" `
    --assignee $identityClientId01 `
    --scope "/subscriptions/$Env:FNIETOGA_SUBSCRIPTION_ID/resourceGroups/$resourceGroupName01"
az identity federated-credential create `
    --name "crossplain-azure-deploy" `
    --identity-name $identityName01 `
    --resource-group $resourceGroupName01 `
    --issuer $clusterIssuer `
    --subject "system:serviceaccount:crossplane-system:crossplain-azure-deploy"
    
##Deploy crossplane config for testapp-01
$rootpath = "C:/code/fnietoga/crossplane-poc/azure"
$template = Get-Content $rootpath/testapp01/testapp01_config.yaml -Raw
$template = $template -replace '#{clientID}#',$identityClientId01
$template = $template -replace '#{subscriptionID}#',$Env:FNIETOGA_SUBSCRIPTION_ID
$template = $template -replace '#{tenantID}#',$Env:FNIETOGA_TENANT_ID
$template = $template -replace '#{resourceGroupId}#',$resourceGroupName01
$template | kubectl apply -f -

##Deploy resoutces for testapp-01
kubectl apply -f $rootpath/testapp01/sta.yaml
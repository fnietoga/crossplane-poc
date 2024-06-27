az login --tenant $Env:FNIETOGA_TENANT_ID --use-device-code
az account set --subscription $Env:FNIETOGA_SUBSCRIPTION_ID

$aksResourceGroupName = "RG-WE-D-AKS-01"
$aksClusterName = "aks-we-d-tests-01"
$clusterIssuer=$(az aks show --resource-group $aksResourceGroupName --name $aksClusterName --query "oidcIssuerProfile.issuerUrl" -o tsv)

$resourceGroupName02="RG-WE-D-TESTAPP-02"
$location="uksouth"
$identityName02= "umi-we-d-testapp-02"
az group create --name $resourceGroupName02 --location $location
az identity create --name $identityName02 --resource-group $resourceGroupName02
$identityClientId02=$(az identity show --name $identityName02 -g $resourceGroupName02 --query 'clientId' -o tsv)
az role assignment create `
    --role "Owner" `
    --assignee $identityClientId02 `
    --scope "/subscriptions/$Env:FNIETOGA_SUBSCRIPTION_ID/resourceGroups/$resourceGroupName02"
az identity federated-credential create `
    --name "crossplain-azure-deploy" `
    --identity-name $identityName02 `
    --resource-group $resourceGroupName02 `
    --issuer $clusterIssuer `
    --subject "system:serviceaccount:crossplane-system:crossplain-azure-deploy"
    
##Deploy crossplane config for testapp-02
$rootpath = "C:/code/fnietoga/crossplane-poc/azure"
$template = Get-Content $rootpath/testapp02/testapp02_config.yaml -Raw
$template = $template -replace '#{clientID}#',$identityClientId02
$template = $template -replace '#{subscriptionID}#',$Env:FNIETOGA_SUBSCRIPTION_ID
$template = $template -replace '#{tenantID}#',$Env:FNIETOGA_TENANT_ID
$template = $template -replace '#{resourceGroupId}#',$resourceGroupName02
$template | kubectl apply -f -

##Deploy resoutces for testapp-02
kubectl apply -f $rootpath/testapp02/sta.yaml
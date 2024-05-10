##20240429 - v1.14.5
#https://cert-manager.io/docs/installation/helm/

helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update

helm upgrade --install cert-manager `
--namespace cert-manager `
--create-namespace `
--version v1.14.5 `
--set installCRDs=true `
-f C:\code\fnietoga\crossplane\cert-manager_install\values.yaml `
jetstack/cert-manager


##Azure Managed Identity as workload identity
$AZURE_DEFAULTS_GROUP = "RSG-WE-T-AKS-01"
$CLUSTER_NAME = "aks-we-t-tests-01"
az aks update --name $CLUSTER_NAME --resource-group $AZURE_DEFAULTS_GROUP --enable-oidc-issuer  --enable-workload-identity

$IDENTITY_NAME = "umi-we-t-aks-cert-manager-01"
$DOMAIN_NAME = "poc.fnietoga.me"
$DNS_RESOURCE_GROUP = "fnietoga.me"
az identity create --name $IDENTITY_NAME --resource-group $AZURE_DEFAULTS_GROUP
$IDENTITY_CLIENT_ID=$(az identity show --name $IDENTITY_NAME -g $AZURE_DEFAULTS_GROUP --query 'clientId' -o tsv)
az role assignment create `
    --role "DNS Zone Contributor" `
    --assignee $IDENTITY_CLIENT_ID `
    --scope $(az network dns zone show --name $DOMAIN_NAME -g $DNS_RESOURCE_GROUP -o tsv --query id)
	
$SERVICE_ACCOUNT_NAME = "cert-manager" # This is the default Kubernetes ServiceAccount used by the cert-manager controller.
$SERVICE_ACCOUNT_NAMESPACE = "cert-manager" # This is the default namespace for cert-manager.
$SERVICE_ACCOUNT_ISSUER=$(az aks show --resource-group $AZURE_DEFAULTS_GROUP --name $CLUSTER_NAME --query "oidcIssuerProfile.issuerUrl" -o tsv)
az identity federated-credential create `
  --name "cert-manager" `
  --identity-name $IDENTITY_NAME `
  --resource-group $AZURE_DEFAULTS_GROUP `
  --issuer $SERVICE_ACCOUNT_ISSUER `
  --subject "system:serviceaccount:$($SERVICE_ACCOUNT_NAMESPACE):$($SERVICE_ACCOUNT_NAME)"
  
kubectl apply -f C:\code\fnietoga\crossplane\cert-manager_install\ClusterIssuer_fnietoga_me.yaml

##20240430 - v1.10.0
#https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

$installpath = "C:/code/fnietoga/crossplane-poc/setup/nginx_install"
helm upgrade --install nginx `
--namespace nginx `
--create-namespace `
-f $installpath/values.yaml `
ingress-nginx/ingress-nginx


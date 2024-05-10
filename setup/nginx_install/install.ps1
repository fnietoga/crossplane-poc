##20240430 - v1.10.0
#https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install nginx `
--namespace nginx `
--create-namespace `
-f C:\code\fnietoga\crossplane\nginx_install\values.yaml `
ingress-nginx/ingress-nginx


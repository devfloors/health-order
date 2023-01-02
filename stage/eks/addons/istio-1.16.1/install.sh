aws eks update-kubeconfig --region ap-northeast-2 --name cluster

# lb controller /stage/eks/lb-controller
terraform apply

# prometheus 설치
kubectl apply --server-side -f manifests/setup

kubectl wait \
        --for condition=Established \
        --all CustomResourceDefinition \
        --namespace=monitoring

kubectl apply -f manifests/

curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.16.1 sh -

export PATH="$PATH:/Users/kmov/Documents/tf-k8s-boilerplate/stage/eks/addons/istio-1.16.1/bin"

istioctl operator init
kubectl apply -f istio-demo.yaml

kubectl apply -f samples/addons/kiali.yaml 
kubectl apply -f samples/addons/jaeger.yaml 

kubectl create ns user
kubectl label ns user istio-injection=enabled
kubectl get ns user --show-labels

kubectl apply -f prometheus-rbac.yaml
kubectl apply -f prometheus-operator.yaml

kubectl edit cm -n istio-system kiali  
##################################################
    external_services:
      custom_dashboards:
        enabled: true
      istio:
        root_namespace: istio-system
      prometheus:
        url: "http://prometheus-k8s.monitoring:9090/"
      grafana:
        enabled: true
        in_cluster_url: "http://grafana.monitoring:3000/"
##################################################



# delete 
kubectl delete istiooperators.install.istio.io -n istio-system example-istiocontrolplane

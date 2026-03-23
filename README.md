# TBD Homepage

## Build and push
docker build -t registry.tbd:5000/tbd-homepage:latest .
docker push registry.tbd:5000/tbd-homepage:latest

## Deploy
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
# tbd-homepage
# tbd-homepage

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube start
# minikube addons enable ingress
sudo apt install -y kubectl

kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/config.yaml
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/accounts-db.yaml

kubectl expose pod accounts-db-0 --type=NodePort --port=5432 --name=accounts-db-0
kubectl port-forward --address 0.0.0.0 svc/accounts-db-0 5432:5432

sudo apt install lsof
sudo lsof -i -P -n | grep LISTEN

sudo apt install -y postgresql-client

psql --port=5432 --username=accounts-admin --password accounts-db --host=127.0.0.1 
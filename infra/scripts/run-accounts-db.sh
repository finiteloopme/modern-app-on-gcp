# Sleep for 10seconds
# sleep 2m
SERVICE_NAME=accounts-db
echo "Start ${SERVICE_NAME} in Docker..."
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/extras/jwt/jwt-secret.yaml
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/config.yaml
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/accounts-db.yaml
echo "Waiting for POD to be ready..."
while [[ $(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 1; done
POD_NAME=$(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..metadata.name}')
sudo -u ${NEW_USER} kubectl expose pod ${POD_NAME} --type=NodePort --port=5432 --name=${SERVICE_NAME}-svc
sleep 10 # Allow time to expose Service
sudo -u ${NEW_USER} kubectl port-forward --address 0.0.0.0 svc/${SERVICE_NAME}-svc 5432:5432 &
echo "Done starting ${SERVICE_NAME} in Docker."

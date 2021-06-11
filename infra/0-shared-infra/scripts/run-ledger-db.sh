# Sleep for 10seconds
# sleep 2m
SERVICE_NAME=ledger-db
echo "Start ${SERVICE_NAME} in Docker..."
# sudo docker run \
#     -d \
#     -p 5432:5432 \
#     --name ${SERVICE_NAME} \
#     --volume=postgresdb:/var/lib/postgresql/data \
#     -e POSTGRES_DB=postgresdb \
#     -e POSTGRES_USER=admin \
#     -e POSTGRES_PASSWORD=password \
#     -e SPRING_DATASOURCE_URL=jdbc:postgresql://ledger-db:5432/postgresdb \
#     -e SPRING_DATASOURCE_USERNAME=admin \
#     -e SPRING_DATASOURCE_PASSWORD=password \
#     -e USE_DEMO_DATA="True" \
#     -e DEMO_LOGIN_USERNAME="testuser" \
#     -e DEMO_LOGIN_PASSWORD="password" \
#     -e LOCAL_ROUTING_NUM="883745000" \
#     -e PUB_KEY_PATH="/root/.ssh/publickey" \
#     gcr.io/bank-of-anthos/ledger-db
# # sleep 10
# sudo docker ps
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/extras/jwt/jwt-secret.yaml
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/config.yaml
sudo -u ${NEW_USER} kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/bank-of-anthos/master/kubernetes-manifests/ledger-db.yaml
echo "Waiting for POD to be ready..."
while [[ $(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for pod" && sleep 1; done
POD_NAME=$(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..metadata.name}')
sudo -u ${NEW_USER} kubectl expose pod ${POD_NAME} --type=NodePort --port=5432 --name=${SERVICE_NAME}-svc
#sudo -u ${NEW_USER} kubectl expose pod ${SERVICE_NAME}-0 --type=NodePort --port=5432 --name=${SERVICE_NAME}-0
sleep 10 # Allow time to expose service
sudo -u ${NEW_USER} kubectl port-forward --address 0.0.0.0 svc/${SERVICE_NAME}-svc 5432:5432 &
echo "Done starting ${SERVICE_NAME} in Docker."
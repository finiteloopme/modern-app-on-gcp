#!/bin/bash
# Get all the GCE instances used for modern-gcp-app
BUS_LOGIC_TAG=bus-logic
KUBE_MANIFESTS=kubernetes-manifests
DEST_FOLDER=${KUBE_MANIFESTS}/tmp
NEW_USER=developer
instance=$(gcloud compute instances list --filter="tags.items ~ ${BUS_LOGIC_TAG}" --format="value[separator=','](name,zone)")
echo "Configuring: ${instance}"
name="${instance%,*}";
zone="${instance#*,}";
gcloud compute scp install-prerequisites.sh $name:~/ --zone=$zone 
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${KUBE_MANIFESTS}/secret/"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/config.yaml"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/ledger-db-config.yaml"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/balance-reader.yaml"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/ledger-writer.yaml"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/transaction-history.yaml"
gcloud compute ssh $name --zone=$zone --command="source wait-for-ready-status.sh; wait_for_ready_status ledgerwriter 8080 8080 &"
gcloud compute ssh $name --zone=$zone --command="source wait-for-ready-status.sh; wait_for_ready_status balancereader 8080 8081 &"
gcloud compute ssh $name --zone=$zone --command="source wait-for-ready-status.sh; wait_for_ready_status transactionhistory 8080 8082 &"
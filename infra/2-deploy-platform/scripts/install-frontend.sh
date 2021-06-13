#!/bin/bash
# Get all the GCE instances used for modern-gcp-app
FRONTEND_TAG=frontend
KUBE_MANIFESTS=kubernetes-manifests
DEST_FOLDER=${KUBE_MANIFESTS}/tmp
NEW_USER=developer
instance=$(gcloud compute instances list --filter="tags.items ~ ${FRONTEND_TAG}" --format="value[separator=','](name,zone)")
echo "Configuring: ${instance}"
name="${instance%,*}";
zone="${instance#*,}";
gcloud compute scp install-prerequisites.sh $name:~/ --zone=$zone 
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${KUBE_MANIFESTS}/secret/"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/config.yaml"
gcloud compute ssh $name --zone=$zone --command="sudo -u ${NEW_USER} kubectl apply -f ${DEST_FOLDER}/frontend.yaml"
gcloud compute ssh $name --zone=$zone --command="source wait-for-ready-status.sh; wait_for_ready_status frontend 8080 8080"
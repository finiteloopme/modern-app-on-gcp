#!/bin/bash
# Get all the GCE instances used for modern-gcp-app
MODERN_GCP_APP_TAG=modern-gcp-app
#for instance in $(gcloud compute instances list --filter="tags.items ~ .${MODERN_GCP_APP_TAG}." --format='value[separator=","](name,zone)'); do
for instance in $(gcloud compute instances list --filter="tags.items ~ ${MODERN_GCP_APP_TAG}" --format="value[separator=','](name,zone)"); do
    echo "Working on: ${instance}"
    name="${instance%,*}";
    zone="${instance#*,}";
    gcloud compute scp install-prerequisites.sh $name:~/ --zone=$zone 
    gcloud compute ssh $name --zone=$zone --command="ls -al" &
done
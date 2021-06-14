#!/bin/bash
# Get all the GCE instances used for modern-gcp-app
# These tags have been set at VM provisioning time
MODERN_GCP_APP_TAG=modern-gcp-app
FRONTEND_TAG=frontend
BUS_LOGIC_TAG=bus-logic
USER_LOGIC_TAG=user-logic
LEDGER_DB_TAG=ledger-db
ACCOUNTS_DB_TAG=accounts-db

# Get the project ID
PROJECT_ID=$(gcloud config get-value project)

# Construct the internal DNS name to the following format
# INSTANCE_NAME.ZONE.c.PROJECT_ID.internal
FRONTEND_HOST=$(gcloud compute instances list --filter="tags.items ~ ${FRONTEND_TAG}" --format="value[separator='.'](name,zone)").c.${PROJECT_ID}.internal
BUS_LOGIC_HOST=$(gcloud compute instances list --filter="tags.items ~ ${BUS_LOGIC_TAG}" --format="value[separator='.'](name,zone)").c.${PROJECT_ID}.internal
USER_LOGIC_HOST=$(gcloud compute instances list --filter="tags.items ~ ${USER_LOGIC_TAG}" --format="value[separator='.'](name,zone)").c.${PROJECT_ID}.internal
ACCOUNTS_DB_HOST=$(gcloud compute instances list --filter="tags.items ~ ${ACCOUNTS_DB_TAG}" --format="value[separator='.'](name,zone)").c.${PROJECT_ID}.internal
LEDGER_DB_HOST=$(gcloud compute instances list --filter="tags.items ~ ${LEDGER_DB_TAG}" --format="value[separator='.'](name,zone)").c.${PROJECT_ID}.internal

TRANSACTIONS_PORT=8080
BALANCES_PORT=8081
HISTORY_PORT=8082
CONTACTS_PORT=8080
USERSERVICE_PORT=8081
ACCOUNTS_DB_PORT=5432
LEDGER_DB_PORT=5432
FRONTEND_PORT=8080

# Construct individual service endpoints. i.e. hostname:port
TRANSACTIONS_API_ADDR=${BUS_LOGIC_HOST}:${TRANSACTIONS_PORT}
BALANCES_API_ADDR=${BUS_LOGIC_HOST}:${BALANCES_PORT}
HISTORY_API_ADDR=${BUS_LOGIC_HOST}:${HISTORY_PORT}
CONTACTS_API_ADDR=${USER_LOGIC_HOST}:${CONTACTS_PORT}
USERSERVICE_API_ADDR=${USER_LOGIC_HOST}:${USERSERVICE_PORT}
ACCOUNTS_DB_API_ADDR=${ACCOUNTS_DB_HOST}:${ACCOUNTS_DB_PORT}
LEDGER_DB_API_ADDR=${LEDGER_DB_HOST}:${LEDGER_DB_PORT}
FRONTEND_API_ADDR=${FRONTEND_HOST}:${FRONTEND_PORT}

KUBE_MANIFESTS=kubernetes-manifests
DEST_FOLDER=${KUBE_MANIFESTS}/tmp
rm -fr ${DEST_FOLDER}
mkdir -p ${DEST_FOLDER}
sed "s/\[ACCOUNTS_DB_API_ADDR\]/${ACCOUNTS_DB_API_ADDR}/g" ./${KUBE_MANIFESTS}/accounts-db-config.yaml > ./${DEST_FOLDER}/accounts-db-config.yaml

sed "s/\[BALANCES_PORT\]/${BALANCES_PORT}/g" ./${KUBE_MANIFESTS}/balance-reader.yaml > ./${DEST_FOLDER}/balance-reader.yaml

sed "s/\[TRANSACTIONS_API_ADDR\]/${TRANSACTIONS_API_ADDR}/g;
     s/\[HISTORY_API_ADDR\]/${HISTORY_API_ADDR}/g;
     s/\[BALANCES_API_ADDR\]/${BALANCES_API_ADDR}/g;
     s/\[CONTACTS_API_ADDR\]/${CONTACTS_API_ADDR}/g;
     s/\[USERSERVICE_API_ADDR\]/${USERSERVICE_API_ADDR}/g
    " ./${KUBE_MANIFESTS}/config.yaml > ./${DEST_FOLDER}/config.yaml

sed "s/\[CONTACTS_PORT\]/${CONTACTS_PORT}/g" ./${KUBE_MANIFESTS}/contacts.yaml > ./${DEST_FOLDER}/contacts.yaml

sed "s/\[LEDGER_DB_API_ADDR\]/${LEDGER_DB_API_ADDR}/g" ./${KUBE_MANIFESTS}/ledger-db-config.yaml > ./${DEST_FOLDER}/ledger-db-config.yaml

sed "s/\[TRANSACTIONS_PORT\]/${TRANSACTIONS_PORT}/g" ./${KUBE_MANIFESTS}/ledger-writer.yaml > ./${DEST_FOLDER}/ledger-writer.yaml

sed "s/\[FRONTEND_API_ADDR\]/${FRONTEND_API_ADDR}/g" ./${KUBE_MANIFESTS}/loadgenerator.yaml > ./${DEST_FOLDER}/loadgenerator.yaml

sed "s/\[HISTORY_PORT\]/${HISTORY_PORT}/g" ./${KUBE_MANIFESTS}/transaction-history.yaml > ./${DEST_FOLDER}/transaction-history.yaml

sed "s/\[USERSERVICE_PORT\]/${USERSERVICE_PORT}/g" ./${KUBE_MANIFESTS}/userservice.yaml > ./${DEST_FOLDER}/userservice.yaml

sed "s/\[FRONTEND_PORT\]/${FRONTEND_PORT}/g" ./${KUBE_MANIFESTS}/frontend.yaml > ./${DEST_FOLDER}/frontend.yaml

# Manually copy the remaining yaml files to destination as we will use destination for kube deployment
cp ./${KUBE_MANIFESTS}/ledger-db.yaml ./${DEST_FOLDER}/ledger-db.yaml
cp ./${KUBE_MANIFESTS}/accounts-db.yaml ./${DEST_FOLDER}/accounts-db.yaml

# Copy scripts & config files to all the VM instances
for instance in $(gcloud compute instances list --filter="tags.items ~ ${MODERN_GCP_APP_TAG}" --format="value[separator=','](name,zone)"); do
    echo "Working on: ${instance}"
    name="${instance%,*}";
    zone="${instance#*,}";

    gcloud compute ssh $name --zone=$zone --command="rm -fr ${KUBE_MANIFESTS}; rm -fr ${DEST_FOLDER}; mkdir -p ${KUBE_MANIFESTS}; mkdir ${DEST_FOLDER}; rm -fr ${KUBE_MANIFESTS}/secret; mkdir -p ${KUBE_MANIFESTS}/secret"
    gcloud compute scp *.sh $name:~/ --zone=$zone 
    gcloud compute scp ${KUBE_MANIFESTS}/*.yaml $name:~/${KUBE_MANIFESTS}/ --zone=$zone 
    gcloud compute scp ${KUBE_MANIFESTS}/secret/*.yaml $name:~/${KUBE_MANIFESTS}/secret/ --zone=$zone 
    gcloud compute scp ${DEST_FOLDER}/*.yaml $name:~/${DEST_FOLDER}/ --zone=$zone 
    # gcloud compute ssh $name --zone=$zone --command="./install-prerequisites.sh"
    pids[${i}]=$!
done

# Wait for all pids
for pid in ${pid[*]}; do
    echo "Waiting for install-prerequisites.sh to finish ${pid}"
    wait $pid
done
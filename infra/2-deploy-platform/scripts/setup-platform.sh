#!/bin/bash
# Get all the GCE instances used for modern-gcp-app
# These tags have been set at VM provisioning time
MODERN_GCP_APP_TAG=modern-gcp-app
FRONTEND_TAG=frontend
BUS_LOGIC_TAG=bus-logic
USER_LOGIC_TAG=user-logic
LEDGER_DB_TAG=ledger-db
ACCOUNTS_DB_TAG=accounts-db

for instance in $(gcloud compute instances list --filter="tags.items ~ ${MODERN_GCP_APP_TAG}" --format="value[separator=','](name,zone)"); do
    echo "Working on: ${instance}"
    name="${instance%,*}";
    zone="${instance#*,}";
    gcloud compute scp install-prerequisites.sh $name:~/ --zone=$zone 
    gcloud compute ssh $name --zone=$zone --command="./install-prerequisites.sh"
done

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

# Construct individual service endpoints. i.e. hostname:port
TRANSACTIONS_API_ADDR=${BUS_LOGIC_HOST}:${TRANSACTIONS_PORT}
BALANCES_API_ADDR=${BUS_LOGIC_HOST}:${BALANCES_PORT}
HISTORY_API_ADDR=${BUS_LOGIC_HOST}:${HISTORY_PORT}
CONTACTS_API_ADDR=${USER_LOGIC_HOST}:${CONTACTS_PORT}
USERSERVICE_API_ADDR=${USER_LOGIC_HOST}:${USERSERVICE_PORT}
ACCOUNTS_DB_API_ADDR=${ACCOUNTS_DB_HOST}:${ACCOUNTS_DB_PORT}
LEDGER_DB_API_ADDR=${LEDGER_DB_HOST}:${LEDGER_DB_PORT}

# sed "s/\[ACCOUNTS_DB_API_ADDR\]/${ACCOUNTS_DB_API_ADDR}/g" ./kubernetes-manifests/accounts-db.yaml > ./kubernetes-manifests/accounts-db.yaml

# sed "s/\[BALANCES_PORT\]/${BALANCES_PORT}/g" ./kubernetes-manifests/balance-reader.yaml > ./kubernetes-manifests/balance-reader.yaml

# sed "s/\[TRANSACTIONS_API_ADDR\]/${TRANSACTIONS_API_ADDR}/g" ./kubernetes-manifests/config.yaml > ./kubernetes-manifests/config.yaml
# sed "s/\[BALANCES_API_ADDR\]/${BALANCES_API_ADDR}/g" ./kubernetes-manifests/config.yaml > ./kubernetes-manifests/config.yaml
# sed "s/\[HISTORY_API_ADDR\]/${HISTORY_API_ADDR}/g" ./kubernetes-manifests/config.yaml > ./kubernetes-manifests/config.yaml
# sed "s/\[CONTACTS_API_ADDR\]/${CONTACTS_API_ADDR}/g" ./kubernetes-manifests/config.yaml > ./kubernetes-manifests/config.yaml
# sed "s/\[USERSERVICE_API_ADDR\]/${USERSERVICE_API_ADDR}/g" ./kubernetes-manifests/config.yaml > ./kubernetes-manifests/config.yaml

# sed "s/\[CONTACTS_PORT\]/${CONTACTS_PORT}/g" ./kubernetes-manifests/contacts.yaml > ./kubernetes-manifests/contacts.yaml

# sed "s/\[LEDGER_DB_API_ADDR\]/${LEDGER_DB_API_ADDR}/g" ./kubernetes-manifests/ledger-db.yaml > ./kubernetes-manifests/ledger-db.yaml

# sed "s/\[TRANSACTIONS_PORT\]/${TRANSACTIONS_PORT}/g" ./kubernetes-manifests/ledger-writer.yaml > ./kubernetes-manifests/ledger-writer.yaml

# sed "s/\[FRONTEND_HOST\]/${FRONTEND_HOST}/g" ./kubernetes-manifests/loadgenerator.yaml > ./kubernetes-manifests/loadgenerator.yaml

# sed "s/\[TRANSACTIONS_PORT\]/${TRANSACTIONS_PORT}/g" ./kubernetes-manifests/transaction-history.yaml > ./kubernetes-manifests/transaction-history.yaml

# sed "s/\[USERSERVICE_PORT\]/${USERSERVICE_PORT}/g" ./kubernetes-manifests/userservice.yaml > ./kubernetes-manifests/userservice.yaml
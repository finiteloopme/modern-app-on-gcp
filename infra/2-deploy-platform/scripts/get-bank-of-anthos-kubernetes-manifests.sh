#!/bin/bash
KUBE_MANIFEST_DIR=kubernetes-manifests
rm -fr ${KUBE_MANIFEST_DIR}
mkdir -p ${KUBE_MANIFEST_DIR}

cd ${KUBE_MANIFEST_DIR}
manifest_list=("accounts-db" "balance-reader" "config" "contacts" "frontend" "ledger-db" "ledger-writer" "loadgenerator" "transaction-history" "userservice")
for each_manifest in ${manifest_list[@]}; do
    curl -LO https://github.com/GoogleCloudPlatform/bank-of-anthos/raw/master/kubernetes-manifests/${each_manifest}.yaml
done
mkdir -p secret
cd secret
curl -LO https://github.com/GoogleCloudPlatform/bank-of-anthos/raw/master/extras/jwt/jwt-secret.yaml

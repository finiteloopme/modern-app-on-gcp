#!/bin/bash

# export PROJECT_ID=${gcloud config get-value project}
export PROJECT_ID=${1}

# export WORKLOAD_NAME=ledger-monolith
export WORKLOAD_NAME=${3}
export WORKLOAD_VERSION=v0.3
export WORKLOAD_SERVICE_ACCOUNT=$(gcloud projects list --filter="id=${PROJECT_ID}" --format="value(project_number)")-compute@developer.gserviceaccount.com
echo "SA is:" ${WORKLOAD_SERVICE_ACCOUNT}
export WORKLOAD_NAMESPACE=default
export ASM_INSTANCE_TEMPLATE=asm-gce-instance-template
# This value is used from the template created using TF
export SOURCE_INSTANCE_TEMPLATE_NAME=gce-template-for-asm
export SOURCE_INSTANCE_TEMPLATE=$(gcloud compute instance-templates list --filter="name ~ ${SOURCE_INSTANCE_TEMPLATE_NAME}" --format="value(name)")
# export SOURCE_INSTANCE_TEMPLATE=default-instance-template-20210618022619627000000001

# export ASM_CLUSTER=asm-control-plane-cluster
export ASM_CLUSTER_LABEL=${2}
export GCP_REGION=us-central1
# export ASM_REVISION="asm-196-2"
export ASM_REVISION="asm-1102-3"

export INSTANCE_GROUP_NAME=${WORKLOAD_NAME}-gce-asm
export INSTANCE_GROUP_ZONE=${GCP_REGION}-b

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "Installing dependencies..."
  # apt-get install -y google-cloud-sdk
  apt-get install -y google-cloud-sdk-kpt
  apt-get install -y coreutils
  apt-get install -y jq
  apt-get install -y ruby
  echo "Done installing dependencies."
fi

instance=$(gcloud container clusters list --filter="resourceLabels.workload ~ ${ASM_CLUSTER_LABEL}" --format="value[separator=','](name,location)")
echo "Configuring the REGIONAL cluster: ${instance}"
name="${instance%,*}";
location="${instance#*,}";
# Assuming this is a regional cluster
gcloud container clusters get-credentials --region=${location} ${name}
export ASM_CLUSTER=${name}
# gcloud container clusters get-credentials ${ASM_CLUSTER} --region ${GCP_REGION}

kubectl create ns ${WORKLOAD_NAMESPACE}
kubectl label ns ${WORKLOAD_NAMESPACE} istio-injection- istio.io/rev=${ASM_REVISION} --overwrite
# ASM version = 1.9
# curl https://storage.googleapis.com/csm-artifacts/asm/asm_vm_1.9 > asm_vm
# ASM version = 1.10
curl https://storage.googleapis.com/csm-artifacts/asm/asm_vm_1.10 > asm_vm
chmod +x asm_vm

cat > workload-group.yaml <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: WorkloadGroup
metadata:
 name: ${WORKLOAD_NAME}
 namespace: ${WORKLOAD_NAMESPACE}
spec:
 metadata:
   labels:
     app.kubernetes.io/name: ${WORKLOAD_NAME}
     app.kubernetes.io/version: ${WORKLOAD_VERSION}
   annotations:
     security.cloud.google.com/IdentityProvider: google
 template:
   serviceAccount: ${WORKLOAD_SERVICE_ACCOUNT}
EOF
kubectl apply -f workload-group.yaml

cat > workload-service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
 name: ${WORKLOAD_NAME}
 namespace: default
 labels:
   asm_resource_type: VM
spec:
 ports:
 - name: http
   port: 8080
   protocol: TCP
   targetPort: 8080
 - name: postgres
   port: 5432
   protocol: TCP
   targetPort: 5432
 selector:
   app.kubernetes.io/name: ${WORKLOAD_NAME}
EOF
kubectl apply -f workload-service.yaml

./asm_vm create_gce_instance_template \
${ASM_INSTANCE_TEMPLATE} \
--project_id ${PROJECT_ID} \
--cluster_location ${GCP_REGION} \
--cluster_name ${ASM_CLUSTER} \
--workload_name ${WORKLOAD_NAME} \
--workload_namespace ${WORKLOAD_NAMESPACE} \
--source_instance_template ${SOURCE_INSTANCE_TEMPLATE}

gcloud compute instance-groups managed create \
${INSTANCE_GROUP_NAME} \
--template ${ASM_INSTANCE_TEMPLATE} \
--zone=${INSTANCE_GROUP_ZONE} \
--project=${PROJECT_ID} \
--size=1

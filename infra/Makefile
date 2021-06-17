GCP_PROJECT=kunal-scratch
GCP_REGION=us-central1
GCP_ZONE=${GCP_REGION}-b
TF_PLAN=infra.tfplan
SHARED_INFRA=0-shared-infra
VMS=1-compute-vms
# DEPLOY_PF=2-deploy-platform
DEPLOY_PF=1-setup-platform
DEPLOY_MONOLITH=2-deploy-monolith
CLUSTER_LABEL=bank-of-anthos
enable-compute:
	gcloud services enable compute.googleapis.com
	
delete-vms:
	terraform destroy -target=module.gce_instances

clean: platform-clean vms-clean infra-clean

auth:
	gcloud auth application-default login

infra: enable-compute
	cd ${SHARED_INFRA}; terraform init
	cd ${SHARED_INFRA}; terraform plan -out=${TF_PLAN}
	cd ${SHARED_INFRA}; terraform apply ${TF_PLAN}

infra-clean: enable-compute
	cd ${SHARED_INFRA}; terraform destroy -auto-approve

vms: enable-compute
	cd ${VMS}; terraform init
	cd ${VMS}; terraform plan -out=${TF_PLAN}
	cd ${VMS}; terraform apply ${TF_PLAN}
	
vms-clean: enable-compute
	cd ${VMS}; terraform destroy -auto-approve

platform: enable-compute
	# cd ${DEPLOY_PF}; gcloud beta builds submit --config ./scripts/cloudbuild.yaml ./scripts
	cd ${DEPLOY_PF}; terraform init
	cd ${DEPLOY_PF}; terraform plan -out=${TF_PLAN}
	cd ${DEPLOY_PF}; terraform apply ${TF_PLAN}

platform-clean: enable-compute
	cd ${DEPLOY_PF}; terraform destroy -auto-approve

monolith-deploy:
	cd ${DEPLOY_MONOLITH}; gcloud builds submit --config ./cloudbuild-deploy.yaml --substitutions=_PROJECT_ID=${GCP_PROJECT},_GCP_ZONE=${GCP_ZONE},_CLUSTER_LABEL=${CLUSTER_LABEL} ./scripts

monolith-clean:
	cd ${DEPLOY_MONOLITH}; gcloud builds submit --config ./cloudbuild-cleanup.yaml --substitutions=_PROJECT_ID=${GCP_PROJECT},_GCP_ZONE=${GCP_ZONE},_CLUSTER_LABEL=${CLUSTER_LABEL} ./scripts

clean-tf:
	rm -fr ./**/.terraform
	
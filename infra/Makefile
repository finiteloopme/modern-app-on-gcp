# GCP_PROJECT=kl-dev-scratchpad
GCP_PROJECT=kunal-scratch
GCP_REGION=us-central1
GCP_ZONE=${GCP_REGION}-b
SHARED_INFRA=0-shared-infra
DEPLOY_PF=1-setup-platform
DEPLOY_MONOLITH=2-deploy-monolith
CLUSTER_LABEL=bank-of-anthos
TF_PLAN=${GCP_PROJECT}-infra.tfplan
MONOLITH_SERVICE=ledger-monolith
enable-compute:
	gcloud services enable compute.googleapis.com
	
clean: monolith-clean platform-clean infra-clean

auth:
	gcloud auth application-default login

infra: enable-compute
	cd ${SHARED_INFRA}; terraform init
	cd ${SHARED_INFRA}; terraform plan -out=${TF_PLAN}
	cd ${SHARED_INFRA}; terraform apply ${TF_PLAN}

infra-clean: enable-compute
	cd ${SHARED_INFRA}; terraform destroy -auto-approve

platform-deploy: enable-compute
	cd ${DEPLOY_PF}; terraform init
	cd ${DEPLOY_PF}; terraform plan -out=${TF_PLAN}
	cd ${DEPLOY_PF}; terraform apply ${TF_PLAN}

platform-clean: enable-compute
	cd ${DEPLOY_PF}; terraform destroy -auto-approve

monolith-deploy:
	cd ${DEPLOY_MONOLITH}; gcloud builds submit --config ./cloudbuild-deploy.yaml --substitutions=_PROJECT_ID=${GCP_PROJECT},_CLUSTER_LABEL=${CLUSTER_LABEL},_MONOLITH_SERVICE=${MONOLITH_SERVICE} ./scripts

monolith-clean:
	cd ${DEPLOY_MONOLITH}; gcloud builds submit --config ./cloudbuild-cleanup.yaml --substitutions=_PROJECT_ID=${GCP_PROJECT},_CLUSTER_LABEL=${CLUSTER_LABEL},_MONOLITH_SERVICE=${MONOLITH_SERVICE} ./scripts

clean-tf:
	rm -fr ./**/.terraform
	
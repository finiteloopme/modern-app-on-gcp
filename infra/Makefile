TF_PLAN=infra.tfplan
SHARED_INFRA=0-shared-infra
VMS=1-compute-vms
DEPLOY_PF=2-deploy-platform
enable-compute:
	gcloud services enable compute.googleapis.com
	
delete-vms:
	terraform destroy -target=module.gce_instances

clean: enable-compute
	terraform destroy

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
	cd ${DEPLOY_PF}; gcloud beta builds submit --config ./scripts/cloudbuild.yaml ./scripts

clean-tf:
	rm -fr ./**/.terraform
	
TF_PLAN=infra.tfplan

enable-compute:
	gcloud services enable compute.googleapis.com
	
plan: enable-compute
	terraform plan -out=${TF_PLAN}

apply:
	terraform apply ${TF_PLAN}

delete-vms:
	terraform destroy -target=module.gce_instances

clean: enable-compute
	terraform destroy

auth:
	gcloud auth application-default login

vms: plan apply

init:
	terraform init

clean-tf:
	rm -fr .terraform
	
TF_PLAN=infra.tfplan

enable-compute:
	gcloud services enable compute.googleapis.com
	
plan: enable-compute
	terraform plan -out=${TF_PLAN}

apply:
	terraform apply ${TF_PLAN}

clean: enable-compute
	terraform destroy

auth:
	gcloud auth application-default login
	
init:
	terraform init

clean-tf:
	rm -fr .terraform
	
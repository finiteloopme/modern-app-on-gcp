export PROJECT_ID=kl-dev-scratchpad
export PRJ_USER=kunall@google.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/servicemanagement.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/serviceusage.serviceUsageAdmin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/meshconfig.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/compute.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/container.admin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/iam.serviceAccountAdmin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/iam.serviceAccountKeyAdmin
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=user:${PRJ_USER} \
    --role=roles/gkehub.admin

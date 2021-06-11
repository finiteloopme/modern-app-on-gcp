    -e POSTGRES_DB=accounts-db \
    -e POSTGRES_USER=accounts-admin \
    -e POSTGRES_PASSWORD=accounts-pwd \
    -e ACCOUNTS_DB_URI=postgresql://accounts-admin:accounts-pwd@accounts-db:5432/accounts-db \

/snap/bin/yq e '.spec.template.spec.containers[0].env[] | select(.name == "PORT") | .value = "8081"' -i contacts.yaml
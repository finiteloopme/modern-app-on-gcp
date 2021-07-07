# 1. Setup pre-requisites & platform
```bash
# Clone the source code repository
git clone https://github.com/finiteloopme/modern-app-on-gcp
cd modern-app-on-gcp/infra
# Setup the project
make infra
# Setup platform
make platform-deploy
cd 2-deploy-monolith/scripts/
./deploy-monolith-in-asm.sh kunal-scratch bank-of-anthos ledger-monolith
# Configure ledger-monolith to bind postgresql to 0.0.0.0
gcloud compute ssh --zone=us-central1-b ledger-monolith-gce-asm-bmq1
sudo bash -c "cat <<EOF >> /etc/postgresql/11/main/postgresql.conf
listen_addresses = '*'
EOF"
sudo bash -c "sudo cat <<EOF >> /etc/postgresql/11/main/pg_hba.conf
host    all             all             0.0.0.0/0               md5
host    all             all             ::/0                    md5
EOF"
sudo service postgresql@11-main stop
sudo service postgresql@11-main start
logout
./deploy-microservices.sh kunal-scratch bank-of-anthos ledger-monolith
```

# 2. Application changes
```bash
cd ../../../app
# Create ingress
make ingress-install
# Expose frontend directly to the internet
make expose-frontend
# Deploy microservices
make microservices-install
# Route traffic to the microservices
make traffic-to-microservices
```


# Scratchpad notes
## https://www.bigbinary.com/blog/configure-postgresql-to-allow-remote-connection
## Service restart
```
sudo service postgresql@11-main stop
sudo service postgresql@11-main start
```
## Bind PostgreSQL to 0.0.0.0
```
sudo vim ./etc/postgresql/11/main/postgresql.conf
```

## Allow remote connection
```
sudo vim ./etc/postgresql/11/main/pg_hba.conf
```

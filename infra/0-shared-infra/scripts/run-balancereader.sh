# Sleep for 10seconds
# sleep 2m
echo "Start balancereader in Docker..."
sudo docker run \
    -d \
    -P \
    --name balancereader \
    --volume=publickey:/root/.ssh \
    -e VERSION="v0.4.3" \
    -e PORT=8080 \
    -e ENABLE_TRACING="true" \
    -e ENABLE_METRICS="true" \
    -e POLL_MS="100" \
    -e CACHE_SIZE="1000000" \
    -e JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap" \
    -e LOG_LEVEL="info" \
    -e PUB_KEY_PATH="/root/.ssh/publickey" \
    -e ACCOUNTS_DB_URI=postgresql://accounts-admin:accounts-pwd@accounts-db:5432/accounts-db \
    gcr.io/bank-of-anthos/balancereader
# sleep 10
sudo docker ps
echo "Done starting balancereader in Docker."
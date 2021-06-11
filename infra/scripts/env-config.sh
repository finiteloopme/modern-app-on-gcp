    -e USE_DEMO_DATA="True" \
    -e DEMO_LOGIN_USERNAME="testuser" \
    -e DEMO_LOGIN_PASSWORD="password" \

  TRANSACTIONS_API_ADDR: "ledgerwriter:8080"
  BALANCES_API_ADDR: "balancereader:8080"
  HISTORY_API_ADDR: "transactionhistory:8080"
  CONTACTS_API_ADDR: "contacts:8080"
  USERSERVICE_API_ADDR: "userservice:8080"

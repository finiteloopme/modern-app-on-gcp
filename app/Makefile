dummy:

get-creds:
	gcloud container clusters get-credentials bank-of-anthos-cluster --region us-central1

ingress-install: 
	# kubectl apply -f ./scripts/configure-mtls.yaml
	kubectl apply -f ./scripts/ingress-gw.yaml

ingress-clean: 
	# kubectl delete -f ./scripts/configure-mtls.yaml
	kubectl delete -f ./scripts/ingress-gw.yaml

mtls-strict:
	kubectl apply -f ./scripts/strict-mtls.yaml

mtls-loose:
	kubectl apply -f ./scripts/permissive-mtls.yaml

mtls-disable:
	kubectl apply -f ./scripts/disable-mtls.yaml

expose-frontend: 
	kubectl expose deployment frontend \
		--port=80 --target-port=8080 \
		--type=LoadBalancer --name=frontend-direct-to-internet

read-microservice-install:
	kubectl apply -f ./scripts/ledger-monolith-db.yaml
	kubectl apply -f https://github.com/finiteloopme/bank-of-anthos/raw/master/kubernetes-manifests/transaction-history.yaml
	kubectl apply -f https://github.com/finiteloopme/bank-of-anthos/raw/master/kubernetes-manifests/balance-reader.yaml

read-microservice-clean:
	kubectl delete -f ./scripts/ledger-monolith-db.yaml
	kubectl delete -f https://github.com/finiteloopme/bank-of-anthos/raw/master/kubernetes-manifests/transaction-history.yaml
	kubectl delete -f https://github.com/finiteloopme/bank-of-anthos/raw/master/kubernetes-manifests/balance-reader.yaml

traffic-to-microservices:
	kubectl apply -f ./scripts/ledger-miroservices-traffic.yaml

traffic-to-monolith:
	kubectl delete -f ./scripts/ledger-miroservices-traffic.yaml

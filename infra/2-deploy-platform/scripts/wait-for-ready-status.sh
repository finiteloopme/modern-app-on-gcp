#!/bin/bash

function wait_for_ready_status(){
    SERVICE_NAME=$1
    SVC_PORT_NUM=$2
    LISTEN_PORT_NUMBER=$3
    NEW_USER=developer
    echo "Activating ${SERVICE_NAME}..."
    while [[ $(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for ${SERVICE_NAME}" && sleep 1; done
    # POD_NAME=$(sudo -u ${NEW_USER} kubectl get pods -l app=${SERVICE_NAME} -o 'jsonpath={..metadata.name}')
    # sudo -u ${NEW_USER} kubectl expose pod ${POD_NAME} --type=NodePort --port=${SVC_PORT_NUM} --name=${SERVICE_NAME}-svc
    # #sleep 10 # Allow time to expose Service
    # sudo -u ${NEW_USER} kubectl port-forward --address 0.0.0.0 svc/${SERVICE_NAME}-svc ${LISTEN_PORT_NUMBER}:${SVC_PORT_NUM} &
    # SVC_NAME=$(sudo -u ${NEW_USER} kubectl get svcs -l app=${SERVICE_NAME} -o 'jsonpath={..metadata.name}')
    #sleep 10 # Allow time to expose Service
    # sudo -u ${NEW_USER} kubectl port-forward --address 0.0.0.0 svc/${SERVICE_NAME} ${LISTEN_PORT_NUMBER}:${SVC_PORT_NUM} &
    MINIKUBE_IP=$(sudo -u ${NEW_USER} minikube ip)
    SERVICE_NODEPORT=$(sudo -u ${NEW_USER} kubectl get service ${SERVICE_NAME} --output='jsonpath="{.spec.ports[0].nodePort}"')
    echo "${SERVICE_NAME} is available at ${MINIKUBE_IP}:${SERVICE_NODEPORT}"
    sudo socat TCP-LISTEN:${LISTEN_PORT_NUMBER},fork TCP:${MINIKUBE_IP}:${SERVICE_NODEPORT} &
    echo "Done starting ${SERVICE_NAME}."

    return
}

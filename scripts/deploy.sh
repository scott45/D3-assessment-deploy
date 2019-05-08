#!/usr/bin/env bash

set -eo pipefail

PROJECT_ID="katedeploy"
CLUSTER_NAME="eatout-kate"
COMPUTE_ZONE="us-central1-a"
DEPLOYMENT_NAME="assessment-kate"
CONTAINER_NAME="kate-app"

installsudo(){
    apt-get update && sudo apt-get install -y sudo
}

installGoogleCloudSdk(){
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install kubectl google-cloud-sdk
}

authWithServiceAccount(){
    echo $SERVICE_KEY > key.txt
    base64 -i key.txt -d > ${HOME}/gcloud-service-key.json
    sudo /opt/google-cloud-sdk/bin/gcloud auth activate-service-account ${ACCOUNT_ID} --key-file ${HOME}/gcloud-service-key.json
}

configureGoogleCloudSdk(){
    sudo /opt/google-cloud-sdk/bin/gcloud config set project $PROJECT_ID
    sudo /opt/google-cloud-sdk/bin/gcloud --quiet config set container/cluster $CLUSTER_NAME
    sudo /opt/google-cloud-sdk/bin/gcloud config set compute/zone $COMPUTE_ZONE
    sudo /opt/google-cloud-sdk/bin/gcloud --quiet container clusters get-credentials $CLUSTER_NAME
    sudo service docker start
}

buildAndTagDockerImage(){
    docker build -t gcr.io/${PROJECT_ID}/flaskkateapp:$CIRCLE_SHA1 .
}

publishDockerImage(){
    sudo /opt/google-cloud-sdk/bin/gcloud docker -- push gcr.io/${PROJECT_ID}/node-app:$CIRCLE_SHA1
}

deployToKubernetesCluster(){
    sudo /opt/google-cloud-sdk/bin/kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=gcr.io/${PROJECT_ID}/flaskkateapp:$CIRCLE_SHA1
}

main() {
    installsudo
    installGoogleCloudSdk
    authWithServiceAccount
    configureGoogleCloudSdk
    buildAndTagDockerImage
    publishDockerImage 
    deployToKubernetesCluster backend
}

main
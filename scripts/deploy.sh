#!/usr/bin/env bash

set -eo pipefail

PROJECT_ID=$PROJECT_ID
CLUSTER_NAME=$CLUSTER_NAME
COMPUTE_ZONE=$COMPUTE_ZONE
DEPLOYMENT_NAME=$DEPLOYMENT_NAME
CONTAINER_NAME=$CONTAINER_NAME
ACCOUNT_ID=$ACCOUNT_ID
DOCKER_REG=$DOCKER_REG

authWithServiceAccount(){
    touch /root/project/key.json
    echo $SERVICE_KEY > /root/project/key.json
    gcloud auth activate-service-account --key-file /root/project/key.json
}

configureGoogleCloudSdk(){
    gcloud config set project $PROJECT_ID
    gcloud --quiet config set container/cluster $CLUSTER_NAME
    gcloud config set compute/zone $COMPUTE_ZONE
    gcloud --quiet container clusters get-credentials $CLUSTER_NAME
}

buildAndTagDockerImage(){
    docker build -t gcr.io/${PROJECT_ID}/flaskkateapp:$CIRCLE_SHA1 .
}

publishDockerImage(){
    touch /root/project/key.json
    echo $SERVICE_KEY > /root/project/key.json
    docker login -u _json_key -p "$(cat /root/project/key.json)" https://gcr.io
    docker push gcr.io/${PROJECT_ID}/flaskkateapp:$CIRCLE_SHA1
}

deployToKubernetesCluster(){
    kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=$DOCKER_REG/${PROJECT_ID}/flaskkateapp:$CIRCLE_SHA1
}

deploymentdone(){
    echo "deployment has been updated"
}

main() {
    authWithServiceAccount
    configureGoogleCloudSdk
    buildAndTagDockerImage
    publishDockerImage 
    deployToKubernetesCluster
    deploymentdone
}

main
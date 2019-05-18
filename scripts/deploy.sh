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
    # echo '{"type": "service_account","project_id": "katedeploy","private_key_id": "e4939194328f911c7703e9e8fb936ca93ebaaf10","private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCq35fnpEzY82E5\nHG7TyqJSoAM065ZNIrwhWqdIjt1BnP+0saIUHi7cDd7CwwD7x4J6q3AhYdDY+m4f\nlkjN+R0z4FZUzJ6wfUJZm5KScOMb+hmLmdG6mjPA+Gm+IVgHdfoOjTdkcj8iAPUM\nBvK7goYyqS21BXRGYBwVw1nkQeGlHIveRnYHVm/lW2YJYN21tuHe3AV5JbxirTzv\nvk+rtQiH+1ahiQIDVMDIX1QsstHOxynCbkVBSLafDgx99BF5k9nJsSqR6tfrHVL4\nRJk3ZF4VSGbI1RXGpxM1NwbAa7UF7zcjoNviODXLsZRMFaIHwo52PqYBMvY2oGz+\nlQ+76rX5AgMBAAECggEABWy+ETr2fBxE8cfY7mUkYGBnXaidj9Mamyn6PdvYQych\neJp7mW0oYnDXycHgX/3yYuPatlqZQ2w27w6Jvu1J263je8N3xcViQ/9ECN1n3mlj\nInsWjRisbDPOwpwjI/B/SPM7hxc38SPL4878KY8QJN9ZXcH/siTGu3ulWNFtIR1g\nsD2hwRldxjD8G12UytaoNuYHHXfg7z6HIOIfRcgPjjrAFIwFiVV/sqzzDHgaOqYF\nKtw9bvFHRu4J0+KiSk7X6gAWTgtnc6iY4WEJbsJK258u2J1GXcTDUW4SYBk3nc5V\noVayCRCfSMMIulu/ndIf9iycSISecuc/N17ukcsHUQKBgQDkN9gjQTv9qtbkgQc4\n12rVpE06BLH/tqa4zFmcl1hsgpYzdqmXvtsSOBQ1Fucg5Qzzv6HwOMHg2fUu1wem\ndP9tjyWpcQaRHCMZ8mWW/lCmpMj3bJXuuNgD+LKPaAUyHQgXanDAuR05BfRvbm+I\nalP6YSO8CByz9JJqCB5pC4BWqQKBgQC/rKqk76UsiOSYIP0lCirCSk7P8kLfD9ij\nTx5c7sNGjKutlOPNs5doUS/Def48cK/aJULAs5pjAnCblsd8BRoET1aq1pSjsioo\nStxPQXZRlpq5GgFrbZRb2eYrIcJhYOdQ+sY3ByCDEcTlkzJ58lyAwlYlxR1WcwAj\ntSg8YrwG0QKBgGpmquuM74ZOD1CL460ZqiKfLq49ICwDoWmJRMJgQYadv5+Q1HL+\nNa8h3DIAUpQgllBSaRLRs3q8w7Yp5NQzuh7/XWTJYHFpN+hR/hFO0pVPQK8yvhiF\nr5jya3W23q1Foc8g/h6sb7Z1U0hcqb1lLXAPuBRjh9ZS0ayDyoHZLeW5AoGBAK2c\nlyA4FHNHN074KnK/R8WeCs7dj2Z98urRAh6JAYVIa0QZpVEvh0esqce0Guzh4NaF\ng3YJ+CAQGLFFHEEgWdVni4fIPvAas4a1b+G12JbEBDb+8CQ/J+8eahXNSURswnid\n/KXhJbiygpazAjhkpxbVb7RcW1tvZMPzFZPElqzRAoGAR3SFTzgbdCzIk2jcnWhp\ny0JffSL+bYMtr60Ep5FxdeA7Li6uQbjsaPo0+l+o4X5w0QoJOZzkR09rVTwzDt/+\nsWhuHmR/2MrPln096mf8qjl79iPwOVSenM4MQlayhcM3mjYhGrYPQ3Eo8RSQRLmz\nw5fInkini4ntCwtxWYFJZqE=\n-----END PRIVATE KEY-----\n","client_email": "katedeploy@katedeploy.iam.gserviceaccount.com","client_id": "107434803269935524286","auth_uri": "https://accounts.google.com/o/oauth2/auth","token_uri": "https://oauth2.googleapis.com/token","auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/katedeploy%40katedeploy.iam.gserviceaccount.com"}' > /root/project/key.json
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
    # docker login -u _json_key -p "$(echo '{"type": "service_account","project_id": "katedeploy","private_key_id": "e4939194328f911c7703e9e8fb936ca93ebaaf10","private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCq35fnpEzY82E5\nHG7TyqJSoAM065ZNIrwhWqdIjt1BnP+0saIUHi7cDd7CwwD7x4J6q3AhYdDY+m4f\nlkjN+R0z4FZUzJ6wfUJZm5KScOMb+hmLmdG6mjPA+Gm+IVgHdfoOjTdkcj8iAPUM\nBvK7goYyqS21BXRGYBwVw1nkQeGlHIveRnYHVm/lW2YJYN21tuHe3AV5JbxirTzv\nvk+rtQiH+1ahiQIDVMDIX1QsstHOxynCbkVBSLafDgx99BF5k9nJsSqR6tfrHVL4\nRJk3ZF4VSGbI1RXGpxM1NwbAa7UF7zcjoNviODXLsZRMFaIHwo52PqYBMvY2oGz+\nlQ+76rX5AgMBAAECggEABWy+ETr2fBxE8cfY7mUkYGBnXaidj9Mamyn6PdvYQych\neJp7mW0oYnDXycHgX/3yYuPatlqZQ2w27w6Jvu1J263je8N3xcViQ/9ECN1n3mlj\nInsWjRisbDPOwpwjI/B/SPM7hxc38SPL4878KY8QJN9ZXcH/siTGu3ulWNFtIR1g\nsD2hwRldxjD8G12UytaoNuYHHXfg7z6HIOIfRcgPjjrAFIwFiVV/sqzzDHgaOqYF\nKtw9bvFHRu4J0+KiSk7X6gAWTgtnc6iY4WEJbsJK258u2J1GXcTDUW4SYBk3nc5V\noVayCRCfSMMIulu/ndIf9iycSISecuc/N17ukcsHUQKBgQDkN9gjQTv9qtbkgQc4\n12rVpE06BLH/tqa4zFmcl1hsgpYzdqmXvtsSOBQ1Fucg5Qzzv6HwOMHg2fUu1wem\ndP9tjyWpcQaRHCMZ8mWW/lCmpMj3bJXuuNgD+LKPaAUyHQgXanDAuR05BfRvbm+I\nalP6YSO8CByz9JJqCB5pC4BWqQKBgQC/rKqk76UsiOSYIP0lCirCSk7P8kLfD9ij\nTx5c7sNGjKutlOPNs5doUS/Def48cK/aJULAs5pjAnCblsd8BRoET1aq1pSjsioo\nStxPQXZRlpq5GgFrbZRb2eYrIcJhYOdQ+sY3ByCDEcTlkzJ58lyAwlYlxR1WcwAj\ntSg8YrwG0QKBgGpmquuM74ZOD1CL460ZqiKfLq49ICwDoWmJRMJgQYadv5+Q1HL+\nNa8h3DIAUpQgllBSaRLRs3q8w7Yp5NQzuh7/XWTJYHFpN+hR/hFO0pVPQK8yvhiF\nr5jya3W23q1Foc8g/h6sb7Z1U0hcqb1lLXAPuBRjh9ZS0ayDyoHZLeW5AoGBAK2c\nlyA4FHNHN074KnK/R8WeCs7dj2Z98urRAh6JAYVIa0QZpVEvh0esqce0Guzh4NaF\ng3YJ+CAQGLFFHEEgWdVni4fIPvAas4a1b+G12JbEBDb+8CQ/J+8eahXNSURswnid\n/KXhJbiygpazAjhkpxbVb7RcW1tvZMPzFZPElqzRAoGAR3SFTzgbdCzIk2jcnWhp\ny0JffSL+bYMtr60Ep5FxdeA7Li6uQbjsaPo0+l+o4X5w0QoJOZzkR09rVTwzDt/+\nsWhuHmR/2MrPln096mf8qjl79iPwOVSenM4MQlayhcM3mjYhGrYPQ3Eo8RSQRLmz\nw5fInkini4ntCwtxWYFJZqE=\n-----END PRIVATE KEY-----\n","client_email": "katedeploy@katedeploy.iam.gserviceaccount.com","client_id": "107434803269935524286","auth_uri": "https://accounts.google.com/o/oauth2/auth","token_uri": "https://oauth2.googleapis.com/token","auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/katedeploy%40katedeploy.iam.gserviceaccount.com"}')" https://gcr.io
    docker login -u _json_key -p $SERVICE_KEY https://gcr.io
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
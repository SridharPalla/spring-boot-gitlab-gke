#!/bin/sh
# Image to deploy
source cicd/shared-scripts/image_name.sh
# Useful Output for Pipeline history
echo "BRANCH: $CI_COMMIT_REF_SLUG"
echo "IMAGE TO USE: $IMAGE"
echo "ENVIRONMENT SLUG: $CI_ENVIRONMENT_SLUG"
ENV_URL=$(echo "$CI_ENVIRONMENT_URL" | cut -d'/' -f3)
echo "ENVIRONMENT URL: $CI_ENVIRONMENT_URL"
echo "NAMESPACE: $KUBE_NAMESPACE"
echo "REPLICAS INIT/MIN: $REPLICA_MIN"
echo "REPLICAS MAX: $REPLICA_MAX"
echo "CPU LIMIT: $CPU_LIMIT"
echo "MEM LIMIT: $MEM_LIMIT" 

# This particular secret is needed by the deployed application's autoscaler to pull images long after the normal Gitlab CI/CD tokens have expired
echo "Create secret..."
if [[ "$CI_PROJECT_VISIBILITY" == "public" ]]; then
    return
else
    kubectl create secret -n "$KUBE_NAMESPACE" \
    docker-registry gitlab-registry-deploy-token \
    --docker-server="$CI_REGISTRY" \
    --docker-username="${REGISTRY_DEPLOY_TOKEN_USER}" \
    --docker-password="${REGISTRY_DEPLOY_TOKEN_PASSWORD}" \
    -o yaml --dry-run | kubectl replace -n "$KUBE_NAMESPACE" --force -f -
fi

# Modify deploy template
sed -i "s/__ENV_URL__/${ENV_URL}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__CI_ENVIRONMENT_SLUG__/${CI_ENVIRONMENT_SLUG}/" cicd/deploy/k8s-manifest.yaml
sed -i "s%__IMAGE__%${IMAGE}%" cicd/deploy/k8s-manifest.yaml
sed -i "s/__KUBE_NAMESPACE__/${KUBE_NAMESPACE}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__KUBE_INGRESS_BASE_DOMAIN__/${KUBE_INGRESS_BASE_DOMAIN}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__REPLICA_MIN__/${REPLICA_MIN}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__REPLICA_MAX__/${REPLICA_MAX}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__CPU_LIMIT__/${CPU_LIMIT}/" cicd/deploy/k8s-manifest.yaml
sed -i "s/__MEM_LIMIT__/${MEM_LIMIT}/" cicd/deploy/k8s-manifest.yaml
# Deploy
kubectl apply -f cicd/deploy/k8s-manifest.yaml

# Check Status of rollout every 10 secs up to 10 mins before proceeding
ATTEMPTS=60
ROLLOUT_STATUS_CMD="kubectl rollout status -n $KUBE_NAMESPACE deployment/$CI_ENVIRONMENT_SLUG --timeout=10s"
until $ROLLOUT_STATUS_CMD || [ "$ATTEMPTS" = 0 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((ATTEMPTS - 1))
    echo "Waiting for rollout to complete. Current status is:"
    kubectl -n "$KUBE_NAMESPACE" get pods
    echo "$ATTEMPTS attempts remaining..."
    sleep 10
done

if $ROLLOUT_STATUS_CMD; then
    kubectl -n "$KUBE_NAMESPACE" get pods
    echo "Deployment rolled out successfully"
    exit 0
else
    kubectl -n "$KUBE_NAMESPACE" get pods
    echo "Deployment failed to rollout within the given time. This can be due to:"
    echo "* a bad specification - download the artifact from this job and verify"
    echo "* not enough time given to the rollout - check the script for details"
    echo "* resource constraints in the cluster"
    echo "* other"
    echo "This job will now exit with a failed state"
    exit 1
fi

#!/bin/sh
# Determine image path tag from branch/tag
if [ "$CI_COMMIT_REF_NAME" = "master" ]; then
    echo "Retagging successful master pipeline to :latest"
else
    echo 'Strange... this job should only be called from master yet came from "$CI_COMMIT_REF_NAME", exiting...'
fi
# Image to retag
source cicd/shared-scripts/image_name.sh
# Retag
echo "Tagging $IMAGE as $CI_REGISTRY_IMAGE:latest"
docker pull "$IMAGE"
docker tag "$IMAGE" "$CI_REGISTRY_IMAGE:latest"
echo "Pushing $CI_REGISTRY_IMAGE:latest"
docker push "$CI_REGISTRY_IMAGE:latest"

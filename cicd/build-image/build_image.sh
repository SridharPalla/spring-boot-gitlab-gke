#!/bin/sh

# Image built on the result of cicd/shared-scripts/image_name.sh
source cicd/shared-scripts/image_name.sh

echo "Building image: $IMAGE"

docker build --rm --no-cache \
  --build-arg BASE_URL="$BASE_URL" \
  --build-arg ITEMS_API_URL="$ITEMS_API_URL" \
  --build-arg TAGS_API_URL="$TAGS_API_URL" \
  --tag "$IMAGE" .

docker push "$IMAGE"

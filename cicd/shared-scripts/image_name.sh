#!/bin/sh
# Informational output for debug and historical reference
echo "CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE"
echo "CI_COMMIT_REF_SLUG=$CI_COMMIT_REF_SLUG"
echo "CI_COMMIT_SHORT_SHA=$CI_COMMIT_SHORT_SHA"
echo "CI_COMMIT_TAG=$CI_COMMIT_TAG"

# Configure domain and tagging based on environment
if [ -z $CI_COMMIT_TAG ]; then
    # Coming from a push/merge
    if [ "$CI_COMMIT_REF_SLUG" == "master" ]; then
        IMAGE_TAG="$CI_COMMIT_REF_SLUG-$CI_COMMIT_SHORT_SHA"
        BASE_URL="https://staging.admin.retail-pim.ingkadt.com"
    else
        IMAGE_TAG="$CI_COMMIT_REF_SLUG-$CI_COMMIT_SHORT_SHA"
        BASE_URL="https://$CI_COMMIT_REF_SLUG.admin.retail-pim.ingkadt.com"
    fi

    ITEMS_API_URL="https://staging.api.retail-pim.ingkadt.com" # Special hack for admin requiring this at build time
    TAGS_API_URL="http://app.product-tagging-service.svc.cluster.local"

    FIREBASE_API_KEY="AIzaSyAYqFTHqzMfrR-n3NrQsB0MCTO4Via2X7E"
    FIREBASE_AUTH_DOMAIN="ikea-retail-pim-dev.firebaseapp.com"
    FIREBASE_DATABASE_URL="https://ikea-retail-pim-dev.firebaseio.com"
    FIREBASE_PROJECT_ID="ikea-retail-pim-dev"
    FIREBASE_STORAGE_BUCKET="ikea-retail-pim-dev.appspot.com"
    FIREBASE_MESSAGING_SENDER_ID="204590270398"
    FIREBASE_APP_ID="1:204590270398:web:3c6a32300df00e560a5bef"
else
    # Coming from a tag
    IMAGE_TAG="$CI_COMMIT_TAG"
    BASE_URL="https://admin.retail-pim.ingka.com"
    ITEMS_API_URL="https://api.retail-pim.ingka.com"
    TAGS_API_URL="http://app.product-tagging-service.svc.cluster.local"

    FIREBASE_API_KEY="AIzaSyCoqa3110X-Nz2ZJ9IIM2qYmwUWwauvOSo"
    FIREBASE_AUTH_DOMAIN="ikea-retail-pim-prod.firebaseapp.com"
    FIREBASE_DATABASE_URL="https://ikea-retail-pim-prod.firebaseio.com"
    FIREBASE_PROJECT_ID="ikea-retail-pim-prod"
    FIREBASE_STORAGE_BUCKET="ikea-retail-pim-prod.appspot.com"
    FIREBASE_MESSAGING_SENDER_ID="376835165618"
    FIREBASE_APP_ID="1:376835165618:web:af4f2da822b3c94ab2a8ab"
fi

IMAGE="$CI_REGISTRY_IMAGE:$IMAGE_TAG"
echo "IMAGE: $IMAGE"
echo "ADMIN URL: $BASE_URL"
echo "ITEMS API ENDPOINT: $ITEMS_API_URL"
echo "TAGS API ENDPOINT: $TAGS_API_URL"

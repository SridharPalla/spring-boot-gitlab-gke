#!/bin/sh

echo "PROJECT: $CI_PROJECT_NAME"
echo "BRANCH: $CI_COMMIT_REF_NAME"
echo "COMMIT: $CI_COMMIT_SHORT_SHA"

cd /home/node
npm run test:ci

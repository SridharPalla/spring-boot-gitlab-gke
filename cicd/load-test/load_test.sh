#!/bin/sh
pwd
docker run -v "$(pwd)"/cicd/load-test:/tmp -e BASE_URL="$(cat environment_url.txt)" loadimpact/k6 run --out json=/tmp/load-test-results.json /tmp/main-test.js

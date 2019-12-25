#!/bin/sh
pwd
docker run -v "$(pwd)"/cicd/stress-test:/tmp -e BASE_URL="$(cat environment_url.txt)" loadimpact/k6 run --out json=/tmp/stress-test-results.json /tmp/stress-test.js

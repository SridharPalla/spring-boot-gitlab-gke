#!/bin/sh
set -e
npm install -g retire
SEVERITY_THRESHOLD="medium"

npm i

echo "Scanning for JS Library Vulnerabilities"
retire -p \
  --ignorefile cicd/sast-retirejs/.retireignore.json \
  --outputformat json \
  --outputpath retirejs-report.json \
  --severity="$SEVERITY_THRESHOLD" \
  --path "$CI_PROJECT_DIR"


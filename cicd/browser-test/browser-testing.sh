#!/bin/sh
# Prepare the environment pre-reqs
export CI_ENVIRONMENT_URL=$(cat environment_url.txt)
URL_FILE=cicd/browser-test/urls.txt
mkdir gitlab-exporter
wget -O gitlab-exporter/index.js https://gitlab.com/gitlab-org/gl-performance/raw/10-5/index.js
mkdir sitespeed-results
echo "urls.txt contains -"
cat $URL_FILE
echo "Inserting domain to URL list.."
sed -i -e "s@^/@$CI_ENVIRONMENT_URL/@" $URL_FILE
cat $URL_FILE
# Execute the testing suite against the URL List
docker run --shm-size=1g --rm -v "$(pwd)":/sitespeed.io sitespeedio/sitespeed.io:9.2.1 --plugins.add ./gitlab-exporter --outputFolder sitespeed-results $URL_FILE
mv sitespeed-results/data/performance.json performance.json

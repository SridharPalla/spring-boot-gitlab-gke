#!/bin/sh
# Pre-reqs
apk add git python py-pip
# Build NodeJsScan
mkdir -p /usr/src/app
cd /usr/src/app
git clone https://github.com/ajinabraham/NodeJsScan.git
cp NodeJsScan/cli.requirements.txt .
cp -r NodeJsScan/core /usr/src/app/core
pip install --no-cache-dir -r cli.requirements.txt
mv NodeJsScan/core/cli.py .

# Execute
python /usr/src/app/cli.py -d "$CI_PROJECT_DIR" -o "$CI_PROJECT_DIR/nodejsscan-report.json"
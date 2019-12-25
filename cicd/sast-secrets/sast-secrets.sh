#!/bin/sh
# Install Trufflehog
apk add git python py-pip
pip install truffleHog
# Install Gitleaks
wget -O /usr/local/bin/gitleaks https://github.com/zricethezav/gitleaks/releases/download/v2.1.0/gitleaks-linux-amd64
chmod +x /usr/local/bin/gitleaks

# Execute
set -e

# RUN Trufflehog
echo "Running trufflehog scan of $(pwd)"
trufflehog --regex --json --exclude_paths=cicd/sast-secrets/trufflehog-excludes.txt "$CI_PROJECT_DIR" > trufflehog-report.json

# RUN Gitleaks
echo "Running Gitleaks scan of $(pwd)"
gitleaks --repo-path="$CI_PROJECT_DIR" --report=gitleaks-report.json
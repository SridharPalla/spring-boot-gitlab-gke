#!/bin/sh
export VERSION="0.2.1"

#### EXPORT CREDS FOR PRIVATE REGISTRY
export TRIVY_AUTH_URL="$CI_REGISTRY"
export TRIVY_USERNAME="$CI_REGISTRY_USER"
export TRIVY_PASSWORD="$CI_REGISTRY_PASSWORD"

#### GET TRIVY
wget -O trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz \
  && tar -C /usr/local/bin/ -zxf trivy.tar.gz \
  && chmod +x /usr/local/bin/trivy

#### DETERMINE IMAGE NAME
source cicd/shared-scripts/image_name.sh

#### EXECUTE SCAN
trivy \
  --no-progress \
  -f json -o image-scanning-report.json \
  --ignorefile cicd/image-scan/.trivyignore \
  --severity MEDIUM,HIGH,CRITICAL \
  --exit-code 1 \
  "$IMAGE"
#!/bin/sh

### INSTALL DEPENDENCIES
apk add bash curl git poppler-utils nodejs npm
curl -s https://detect.synopsys.com/detect.sh -o /tmp/detect.sh && chmod +x /tmp/detect.sh

### EXECUTE SCAN
/tmp/detect.sh --blackduck.url="https://hubeval91.blackducksoftware.com" \
          --blackduck.api.token="$BLACKDUCK_API_KEY" \
          --detect.project.name="RPIM-$CI_PROJECT_NAME" \
          --detect.project.version.name="$CI_COMMIT_REF_NAME" \
          --detect.detector.search.depth=3 \
          --detect.cleanup=false \
          --detect.policy.check.fail.on.severities="ALL" \
          --detect.wait.for.results=true \
          --detect.report.timeout=1200 \
          --detect.source.path="$CI_PROJECT_DIR" \
          --detect.tools="DETECTOR" \
          --detect.risk.report.pdf=true \
          --detect.notices.report=false \
          --detect.risk.report.pdf.path="$CI_PROJECT_DIR/sca-reports" \
          --detect.npm.include.dev.dependencies=false

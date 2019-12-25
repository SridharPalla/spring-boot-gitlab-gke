#!/bin/sh
# Ensure the tag is semVer-like
if (echo "$CI_COMMIT_TAG" | grep -Eq "^v[0-9]+\.[0-9]+\.[0-9]+$"); then
    echo "Semantic Versioning check of tag $CI_COMMIT_TAG passed! Continuing"
    exit 0
else
    echo "The tag $CI_COMMIT_TAG does not look like the correct format"
    echo "You must use semantic versioning in the format v###.###.###"
    echo "EXAMPLES: v0.0.1 v176.12.11 v3.0.0"
    echo "Please tag correctly for the release pipeline to proceed"
    exit 1
fi

#!/usr/bin/env bash

set -ex

env | sort

# Ensure that any modifications or stray files are removed
git clean -df
git checkout .

# BUILD_FLOW_GIT_COMMIT gets set in the build_flow jenkins job.
# This ensures we check out the same git commit for all jenkins jobs in the flow.
if [ -n "$BUILD_FLOW_GIT_COMMIT" ]; then
  git checkout $BUILD_FLOW_GIT_COMMIT
fi

$@

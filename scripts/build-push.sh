#!/usr/bin/env bash

set -e

use_tag="tiangolo/meinheld-gunicorn:$NAME"
use_dated_tag="${use_tag}-$(date -I)"

docker build --squash -t "$use_tag" -f "$DOCKERFILE" "$BUILD_PATH"

docker tag "$use_tag" "$use_dated_tag"

docker push "$use_tag"
docker push "$use_dated_tag"

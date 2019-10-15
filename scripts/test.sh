#!/usr/bin/env bash
set -e

use_tag="tiangolo/meinheld-gunicorn:$NAME"

docker build -t "$use_tag" "$BUILD_PATH"
pytest tests

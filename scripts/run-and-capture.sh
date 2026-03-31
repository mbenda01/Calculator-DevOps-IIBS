#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <image> <nombre> <operateur> <nombre>" >&2
  exit 1
fi

IMAGE="$1"
shift

LOG_FILE="${LOG_FILE:-elk/logs/calculator-demo.log}"
mkdir -p "$(dirname "$LOG_FILE")"

status=0
if ! docker run --rm "$IMAGE" "$@" 2>&1 | tee -a "$LOG_FILE"; then
  status=$?
fi

exit "$status"

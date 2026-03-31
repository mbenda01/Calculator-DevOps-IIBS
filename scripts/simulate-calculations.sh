#!/usr/bin/env bash

set -euo pipefail

IMAGE="${1:-calculator-devops:local}"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_FILE:-elk/logs/calculator-${STAMP}.log}"

mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

echo "Packaging Maven..."
mvn -B -DskipTests clean package

echo "Building Docker image ${IMAGE}..."
docker build -t "$IMAGE" .

run_case() {
  echo "Execution: $*" >&2
  if LOG_FILE="$LOG_FILE" ./scripts/run-and-capture.sh "$IMAGE" "$@"; then
    :
  else
    echo "Execution en erreur capturee pour la demo." >&2
  fi
  sleep 1
}

run_case 10 + 5
run_case 9 - 14
run_case 8 "*" 4
run_case 20 / 5
run_case 10 / 0
run_case -3 + -8

echo "Logs ecrits dans ${LOG_FILE}"
echo "Attendez quelques secondes puis ouvrez Kibana sur http://localhost:5601"

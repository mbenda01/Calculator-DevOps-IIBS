#!/bin/sh
# run-single.sh — Lance un calcul unique ET envoie le log vers Logstash
# Usage : run-single.sh <a> <op> <b>
# Exemples :
#   run-single.sh 10 + 5
#   run-single.sh 6 * 7
#   run-single.sh 10 / 0

LOGSTASH_HOST="logstash"
LOGSTASH_PORT="5000"
JAR="/app/calculator-1.0.jar"

A="$1"; OP="$2"; B="$3"

RES=$(java -jar "$JAR" "$A" "$OP" "$B" 2>&1)
TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
PAYLOAD="{\"timestamp\":\"$TS\",\"operation\":\"$OP\",\"operand_a\":$A,\"operand_b\":$B,\"message\":\"OP=$OP A=$A B=$B $RES\"}"
echo "$PAYLOAD" | nc -w1 "$LOGSTASH_HOST" "$LOGSTASH_PORT" 2>/dev/null || true
echo "$RES"

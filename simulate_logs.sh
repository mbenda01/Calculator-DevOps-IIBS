#!/bin/bash
# simulate_logs.sh
# Simule une série d'exécutions de java-calculator pour alimenter Kibana
# Usage : ./simulate_logs.sh [IMAGE_NAME]

IMAGE="${1:-monuser/java-calculator:v1.0}"
DELAY=1  # secondes entre chaque exécution

echo "========================================"
echo "  Simulation de logs — java-calculator"
echo "  Image : $IMAGE"
echo "========================================"

# ── Additions ──────────────────────────────────────────────
echo "[+] Test additions..."
docker run --rm "$IMAGE" 10 + 5
docker run --rm "$IMAGE" 100 + 200
docker run --rm "$IMAGE" 3 + 7
docker run --rm "$IMAGE" 50 + 50
sleep $DELAY

# ── Soustractions ──────────────────────────────────────────
echo "[-] Test soustractions..."
docker run --rm "$IMAGE" 20 - 8
docker run --rm "$IMAGE" 100 - 45
docker run --rm "$IMAGE" 5 - 10   # résultat négatif
sleep $DELAY

# ── Multiplications ────────────────────────────────────────
echo "[*] Test multiplications..."
docker run --rm "$IMAGE" 8 '*' 4
docker run --rm "$IMAGE" 12 '*' 3
docker run --rm "$IMAGE" 99 '*' 0  # multiplication par zéro
sleep $DELAY

# ── Divisions ──────────────────────────────────────────────
echo "[/] Test divisions..."
docker run --rm "$IMAGE" 20 / 5
docker run --rm "$IMAGE" 100 / 4
docker run --rm "$IMAGE" 7 / 2
sleep $DELAY

# ── Erreurs — Division par zéro ────────────────────────────
echo "[!] Test erreurs division par zéro..."
docker run --rm "$IMAGE" 10 / 0 || true
docker run --rm "$IMAGE" 0 / 0 || true
docker run --rm "$IMAGE" 99 / 0 || true
sleep $DELAY

echo ""
echo "========================================"
echo "  ✅ Simulation terminée !"
echo "  Ouvrez Kibana sur http://localhost:5601"
echo "  Index : calculator-logs-*"
echo "========================================"
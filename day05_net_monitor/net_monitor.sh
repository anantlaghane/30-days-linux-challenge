#!/usr/bin/env bash

REPORT_DIR="reports"
REPORT_TS=$(date +"%F_%H%M%S")
REPORT_FILE="$REPORT_DIR/net_report_$REPORT_TS.json"

mkdir -p "$REPORT_DIR"

echo "Starting Network Traffic Monitor..."
echo "Report will be saved to: $REPORT_FILE"

# --- Active Connections ---
ACTIVE_CONNECTIONS=$(ss -tun | grep -v "State" | wc -l)

# --- External IPs ---
TOP_EXTERNAL_IPS=$(ss -tn | awk '{print $5}' | grep -v -E "127.0.0.1|::1|<IPAddress>" \
| sed 's/:.*//' | sort | uniq -c | sort -rn | head -5)

# --- Port Usage ---
PORT_USAGE=$(ss -ltn | awk 'NR>1 {print $4}' | sed 's/.*://' \
| sort | uniq -c | sort -rn | head -5)

# --- Live Bandwidth (Simple) ---
RX_BEFORE=$(cat /sys/class/net/*/statistics/rx_bytes 2>/dev/null | paste -sd+ | bc)
TX_BEFORE=$(cat /sys/class/net/*/statistics/tx_bytes 2>/dev/null | paste -sd+ | bc)
sleep 1
RX_AFTER=$(cat /sys/class/net/*/statistics/rx_bytes 2>/dev/null | paste -sd+ | bc)
TX_AFTER=$(cat /sys/class/net/*/statistics/tx_bytes 2>/dev/null | paste -sd+ | bc)

RX_RATE=$(( (RX_AFTER - RX_BEFORE) / 1024 ))
TX_RATE=$(( (TX_AFTER - TX_BEFORE) / 1024 ))

# --- Firewall Counters ---
FW_COUNTERS=$(sudo iptables -L INPUT -v -n 2>/dev/null)

echo
echo "🔹 Active Connections: $ACTIVE_CONNECTIONS"
echo
echo "🔹 Top 5 External IPs:"
if [[ -n "$TOP_EXTERNAL_IPS" ]]; then
    echo "$TOP_EXTERNAL_IPS"
else
    echo "No active external connections detected"
fi

echo
echo "🔹 Port Usage (Top 5):"
if [[ -n "$PORT_USAGE" ]]; then
    echo "$PORT_USAGE"
else
    echo "No open ports to report"
fi

echo
echo "🔹 Live Bandwidth Usage (1 sec sample):"
echo "   🟦 Download: ${RX_RATE} KB/s"
echo "   🟥 Upload:   ${TX_RATE} KB/s"

echo
echo "🔹 Firewall packet counters:"
if [[ -n "$FW_COUNTERS" ]]; then
    echo "$FW_COUNTERS"
else
    echo "iptables not available or no counters"
fi

# Save JSON report
cat <<EOF > "$REPORT_FILE"
{
  "timestamp": "$REPORT_TS",
  "active_connections": "$ACTIVE_CONNECTIONS",
  "top_external_ips": "$(echo "$TOP_EXTERNAL_IPS" | tr '\n' ';')",
  "port_usage": "$(echo "$PORT_USAGE" | tr '\n' ';')",
  "bandwidth_rx_kb_s": "$RX_RATE",
  "bandwidth_tx_kb_s": "$TX_RATE"
}
EOF

echo
echo "📦 JSON report generated: $REPORT_FILE"
echo "Network Monitoring Done ✔"
exit 0


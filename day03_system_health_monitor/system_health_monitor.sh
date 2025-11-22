#!/bin/bash

# -----------------------------------------
#  System Health Monitoring Tool 
# -----------------------------------------

LOG_DIR="/var/log/system_health"
LOG_FILE="$LOG_DIR/health_$(date +"%Y-%m-%d_%H-%M-%S").log"

CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=80

mkdir -p $LOG_DIR

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

print_section() {
    echo -e "\n==================== $1 ====================\n" | tee -a "$LOG_FILE"
}

print_alert() {
    echo -e "${RED}[ALERT]${NC} $1" | tee -a "$LOG_FILE"
}

print_ok() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

echo "System Health Report - $(date)" | tee "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# ---------------- CPU USAGE ----------------
print_section "CPU USAGE"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU_INT=${CPU_USAGE%.*}

if (( CPU_INT > CPU_THRESHOLD )); then
    print_alert "High CPU Usage: $CPU_USAGE %"
else
    print_ok "CPU Usage: $CPU_USAGE %"
fi

echo "Top CPU-consuming processes:" | tee -a "$LOG_FILE"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head | tee -a "$LOG_FILE"

# ---------------- RAM USAGE ----------------
print_section "RAM USAGE"

RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
RAM_INT=${RAM_USAGE%.*}

if (( RAM_INT > RAM_THRESHOLD )); then
    print_alert "High RAM Usage: $RAM_USAGE %"
else
    print_ok "RAM Usage: $RAM_USAGE %"
fi

# ---------------- LOAD AVERAGE ----------------
print_section "LOAD AVERAGE"

uptime | tee -a "$LOG_FILE"

# ---------------- DISK USAGE ----------------
print_section "DISK USAGE"

df -h | tee -a "$LOG_FILE"

DISK_ALERT=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if (( DISK_ALERT > DISK_THRESHOLD )); then
    print_alert "Root Disk Usage Critical: $DISK_ALERT %"
else
    print_ok "Root Disk Usage: $DISK_ALERT %"
fi

# ---------------- ZOMBIE PROCESSES ----------------
print_section "ZOMBIE PROCESSES"

ZOMBIES=$(ps aux | grep 'Z' | wc -l)

if (( ZOMBIES > 0 )); then
    print_alert "Zombie Processes Found: $ZOMBIES"
else
    print_ok "No Zombie Processes"
fi

# ---------------- FAILED SERVICES ----------------
print_section "FAILED SERVICES"

FAILED=$(systemctl --failed --no-legend | wc -l)

if (( FAILED > 0 )); then
    print_alert "Failed Services Detected: $FAILED"
    systemctl --failed | tee -a "$LOG_FILE"
else
    print_ok "No Failed Services"
fi

# ---------------- NETWORK CHECK ----------------
print_section "NETWORK CONNECTIVITY"

PING_RESULT=$(ping -c 1 google.com &> /dev/null)

if [[ $? -ne 0 ]]; then
    print_alert "Internet DOWN!"
else
    print_ok "Internet Connected"
fi

echo -e "\nReport saved to: $LOG_FILE"
echo -e "Monitoring Completed ✔"


#!/bin/bash

# -----------------------------------------
#  Service Auto-Heal Script
#  Description:
#     - Monitors critical services (nginx, mysql)
#     - If service stops → auto restart
#     - Sends alert in terminal + log file
# -----------------------------------------

SERVICES=("nginx" "mysql")
LOG_FILE="/var/log/service_autoheal.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Create logfile if not exists
touch $LOG_FILE

echo "================= Auto-Heal Script Started ($DATE) =================" >> $LOG_FILE

for SERVICE in "${SERVICES[@]}"; do
    systemctl is-active --quiet "$SERVICE"

    if [ $? -ne 0 ]; then
        echo "$DATE - ALERT: $SERVICE is DOWN!" | tee -a $LOG_FILE

        echo "Attempting to restart $SERVICE ..." | tee -a $LOG_FILE
        systemctl restart "$SERVICE"

        sleep 2
        systemctl is-active --quiet "$SERVICE"

        if [ $? -eq 0 ]; then
            echo "$DATE - SUCCESS: $SERVICE restarted successfully." | tee -a $LOG_FILE
        else
            echo "$DATE - ERROR: Failed to restart $SERVICE!" | tee -a $LOG_FILE
        fi
    else
        echo "$DATE - OK: $SERVICE is running fine." >> $LOG_FILE
    fi
done


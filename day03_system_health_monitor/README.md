# 🖥️ Day 3 — System Health Monitoring Tool (Bash)

This script automatically monitors system health by checking CPU, RAM, Disk, Load Average, Zombie processes, and failed services — all in one place.
---
## 🚀 Features Implemented

✔ CPU usage monitoring
✔ RAM usage monitoring
✔ Disk usage check
✔ Load average check
✔ Zombie process detection
✔ Failed systemd services list
✔ Color-coded output
✔ Works on all Linux systems
---
## 📂 Project Structure
day03_system_health_monitor/
│── system_health_monitor.sh
│── README.md
---
## 🛠️ How It Works
## 1️⃣ Run Script
chmod +x system_health_monitor.sh
./system_health_monitor.sh

## 2️⃣ What It Shows:

CPU usage %

Memory usage with total/free

Disk usage with mount points

Load average (1/5/15 min)

Zombie processes

Any services that failed
---
📄 Sample Output
=============================
  SYSTEM HEALTH REPORT
=============================

CPU Usage      : 14%
Memory Usage   : 58% (Used: 4.5G / Total: 7.8G)
Disk Usage     : 65% (/dev/sda1)
Load Average   : 0.42 0.37 0.30

Zombie Process : 0

## ⚠️ Failed Services:
- apache2.service
- snapd.service
---
## 🎯 Purpose

This tool helps Linux administrators and DevOps engineers quickly analyze system health in real-time using a single script.

![System Health Output](./day03_system_health_monitor/day03_01.png)
![System Health Output](./day03_system_health_monitor/day03_02.png)
![System Health Output](./day03_system_health_monitor/day03_03.png)

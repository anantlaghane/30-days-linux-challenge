# 🧑‍💻 Day 1 — User Onboarding Automation (Linux Project)

This script automates the complete onboarding process for a new Linux user.

---

## 🚀 Features Implemented

✔ Create a new Linux user  
✔ Set password interactively  
✔ Configure account expiry  
✔ Add SSH Public Key for passwordless authentication  
✔ Generate audit logs  
✔ Error handling included

---

## 📂 Project Structure

```
day01_user_onboarding/
│── user_onboarding.sh
│── user_onboarding.log
│── README.md
```

---

## 🛠️ How It Works

### 1️⃣ Run Script
```bash
sudo ./user_onboarding.sh
```

### 2️⃣ Script Prompts:
- Enter username  
- Set password  
- Enter expiry date  
- Paste SSH public key  

---

## 📄 Log File Example
```
2025-11-20 16:29:32 : User 'jitu1' created.
2025-11-20 16:30:06 : Expiry date set: 2025-12-05
2025-11-20 16:30:09 : SSH key added for jitu1.
```

---

## 🎯 Purpose
This automation is helpful for DevOps engineers to streamline onboarding in Linux servers.

---

## ✨ Author  
**Anant laghane 

---
---


# 🛡️ Day 2 — Linux Hardening Automation (Security Project)

This script automates essential Linux security hardening tasks to protect the system from unauthorized access and enforce strong security policies.
---
## 🚀 Features Implemented

✔ Disable root SSH login
✔ Disable password-based SSH authentication
✔ Enforce key-based authentication
✔ Create a secure sudo user
✔ Apply strong password policies (PAM)
✔ SSH timeout configuration
✔ Enable UFW firewall
✔ Disable unused services
✔ Automatic backup of config files
✔ Undo (rollback) support
✔ Generate logs for every change
---
## 📂 Project Structure
day02_linux_hardening/
│── linux_hardening.sh
│── hardening_undo.sh
│── backup/
│── README.md
---
## 🛠️ How It Works
1️⃣ Run Hardening Script
sudo ./linux_hardening.sh

Script Performs:

Creates backup folder

Disables root login

Disables password login → enables SSH key authentication

Configures SSH timeout

Sets password complexity

Sets up UFW firewall

Creates secure sudo user

Logs all actions
---
## 2️⃣ Run Undo Script (Rollback)

If you want to revert all security changes:

sudo ./hardening_undo.sh
---

The undo script restores:

Default SSH configuration

Root login access

Password authentication

Original firewall state

Default password policy

Removes optional secure user
---
## 📄 Log File Example
2025-11-21 14:52:10 : Backup created at /backup/hardening-2025-11-21
2025-11-21 14:52:12 : Root SSH login disabled.
2025-11-21 14:52:13 : Password authentication disabled.
2025-11-21 14:52:14 : SSH idle timeout enabled.
2025-11-21 14:52:15 : Secure user 'secureadmin' created.
2025-11-21 14:52:17 : UFW firewall enabled.
---
## 🎯 Purpose

This automation helps DevOps engineers quickly apply industry-standard Linux hardening, improve server security, prevent brute-force attacks, enforce password rules, and maintain system compliance.

---
---
---
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
## 📄 Sample Output
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


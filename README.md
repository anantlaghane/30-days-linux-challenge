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


#"Day 2 — Linux Hardening Automation (Security Project)"

description: >
  This script automates essential Linux security hardening tasks to protect
  the system from unauthorized access and enforce strong security policies.

features:
  - Disable root SSH login
  - Disable password-based SSH authentication
  - Enforce key-based authentication
  - Create a secure sudo user
  - Apply strong password policies (PAM)
  - SSH timeout configuration
  - Enable UFW firewall
  - Disable unused services
  - Automatic backup of config files
  - Undo (rollback) support
  - Generate logs for every action

project_structure:
  day02_linux_hardening:
    - linux_hardening.sh
    - hardening_undo.sh
    - backup/
    - README.md

how_it_works:
  run_hardening_script: "sudo ./linux_hardening.sh"
  operations_performed:
    - Create backup folder
    - Disable root login
    - Disable password login (enable SSH key authentication)
    - Configure SSH idle timeout
    - Enforce strong password complexity
    - Enable UFW firewall
    - Create secure sudo user
    - Log all actions
  rollback:
    command: "sudo ./hardening_undo.sh"
    restores:
      - Default SSH configuration
      - Root login access
      - Password authentication
      - Original firewall state
      - Default password policy
      - Optional secure user removal

log_example: |
  2025-11-21 14:52:10 : Backup created at /backup/hardening-2025-11-21
  2025-11-21 14:52:12 : Root SSH login disabled.
  2025-11-21 14:52:13 : Password authentication disabled.
  2025-11-21 14:52:14 : SSH idle timeout enabled.
  2025-11-21 14:52:15 : Secure user 'secureadmin' created.
  2025-11-21 14:52:17 : UFW firewall enabled.

purpose: >
  This automation helps DevOps engineers quickly apply industry-standard
  Linux hardening, improve server security, prevent brute-force attacks,
  enforce password rules, and maintain system compliance.

author: "Anant Laghane"

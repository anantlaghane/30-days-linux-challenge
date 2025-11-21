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
---

📌 Day 2 – Linux Hardening (User, SSH & System Security)

This module contains two automated shell scripts:

1️⃣ linux_hardening.sh (Main Hardening Script)

This script performs essential Linux security hardening:

🔐 Security Enhancements Done

Disables root SSH login

Disables password-based SSH login

Enables only key-based authentication

Sets strong password policies

Creates a new secure sudo user

Configures SSH timeout & restrictions

Firewall (UFW) configuration

Disables unwanted services

System update + upgrade

Log & monitoring improvements

2️⃣ hardening_undo.sh (Rollback Script)

This script reverses the changes made by the hardening script:

🔄 Undo Actions

Re-enable root SSH login

Re-enable password authentication

Remove SSH timeout

Restore default SSH config

Remove created sudo user (optional)

Re-enable services

Rollback UFW rules

Reset password policy

Restore backups created during hardening

📁 How to Run
▶️ Run Hardening
chmod +x linux_hardening.sh
sudo ./linux_hardening.sh

⏪ Undo Hardening
chmod +x hardening_undo.sh
sudo ./hardening_undo.sh

📝 Notes

Always test on a VM before applying on production.

Both scripts create a backup automatically:

/backup/hardening-backup-<date>/


Undo script uses this backup to restore original configuration files.

📌 Deliverables for Day 2

linux_hardening.sh

hardening_undo.sh
     

   

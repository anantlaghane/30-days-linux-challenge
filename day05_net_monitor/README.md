# 🛠 Day 05 — Advanced Log Analyzer (30-Day Linux Project)

The script analyses web server logs and detects key security patterns.

---

## 📌 Features
- Count total log lines
- Top attacking IPs (Brute Force Indicators)
- Top requested URLs
- HTTP Status Code Summary
- DDoS-like traffic pattern detection
- JSON report generation

---

## 🧠 Technologies & Commands Used
| Tool / Command | Purpose |
|----------------|---------|
| `awk`, `grep`, `cut`, `sort`, `uniq` | Log parsing |
| `date` | Report naming |
| Regular Expressions | Pattern matching |
| Bash | Automation |

---



./reports/log_report_<timestamp>.json
📦 Directory Structure
Copy code
day05_log_analyzer/
│
├── log_analyzer.sh
└── reports/
🛡 Sample Detection Capability
✔ Suspicious 401/403 access flood
✔ High request rate on same IP
✔ DDoS-ish behaviour (High request + diverse URLs)

📊 Sample Output

Starting advanced log analysis on: /var/log/nginx/access.log
Total log lines: 35000
Top 10 IPs:
192.168.1.25  →  120 requests
45.35.98.10   →  78 attempts (403 flagged)
...
📅 Challenge Roadmap
Day	Topic
04	Server Auto-Heal Script
05	Log Analyzer
06	Network Traffic Monitor

![User Onboarding Automation](./day05.png) 




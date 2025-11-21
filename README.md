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


<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Day 2 — Linux Hardening Script — README</title>
  <style>
    :root{
      --bg:#0f1724; --card:#0b1220; --accent:#60a5fa; --muted:#94a3b8; --text:#e6eef8;
      --code:#071428;
    }
    body{font-family:Inter,Segoe UI,system-ui,Arial,sans-serif;background:linear-gradient(180deg,#071126 0%, #071d2b 100%);color:var(--text);margin:0;padding:32px;}
    .container{max-width:900px;margin:0 auto;background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));border-radius:12px;padding:28px;box-shadow:0 10px 30px rgba(2,6,23,0.6);}
    h1{margin:0 0 8px;font-size:28px;color:var(--accent);}
    h2{color:#cfe8ff;margin-top:28px}
    p{color:var(--muted);line-height:1.55}
    ul{color:var(--muted);line-height:1.6}
    code, pre{font-family:ui-monospace,SFMono-Regular,Consolas,"Segoe UI Mono",monospace;background:var(--code);color:#c7f0ff;padding:6px;border-radius:6px;}
    pre{padding:14px;overflow:auto;}
    .pill{display:inline-block;background:rgba(255,255,255,0.03);color:var(--muted);padding:6px 10px;border-radius:999px;font-size:13px;margin-right:8px;}
    .note{background:rgba(96,165,250,0.06);border-left:4px solid var(--accent);padding:12px;border-radius:6px;color:var(--muted);margin:14px 0;}
    footer{margin-top:28px;color:var(--muted);font-size:13px}
    .cmd{display:block;margin:10px 0}
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>🔐 Day 2 — Linux Hardening Script</h1>
      <p>A production-minded hardening automation script to apply common security best-practices on Linux servers. Includes backups, dry-run mode, logging and safe restart checks.</p>
    </header>

    <section>
      <h2>✅ Features</h2>
      <ul>
        <li>Disable root SSH login</li>
        <li>Add SSH login banner (legal / monitoring)</li>
        <li>Harden <code>/etc/ssh/sshd_config</code> (PasswordAuthentication, X11Forwarding, Ciphers, MACs)</li>
        <li>Enforce password policy (pwquality / login.defs)</li>
        <li>Enable/Configure firewall (ufw or firewalld)</li>
        <li>Apply sysctl kernel/network hardening</li>
        <li>Disable common unused services</li>
        <li>Install basic <code>fail2ban</code> for SSH protection (optional)</li>
        <li>Backups of modified config files (under <code>/root/hardening_backups_<timestamp></code>)</li>
        <li><strong>--dry-run</strong> mode to preview changes safely</li>
        <li>Safe sshd syntax check before restart</li>
      </ul>
    </section>

    <section>
      <h2>📂 Folder structure</h2>
      <pre><code>day02_linux_hardening/
├── linux_hardening.sh
├── hardening_undo.sh
└── README.html</code></pre>
    </section>

    <section>
      <h2>▶️ How to use (recommended safe flow)</h2>
      <ol>
        <li>Make scripts executable:
          <pre><code class="cmd">chmod +x linux_hardening.sh hardening_undo.sh</code></pre>
        </li>
        <li>Preview changes (dry-run):
          <pre><code class="cmd">sudo ./linux_hardening.sh --dry-run</code></pre>
          <p class="note">Review output &amp; the generated log at <code>/var/log/linux_hardening_*.log</code>. No files are changed in dry-run.</p>
        </li>
        <li>Apply changes (after review):
          <pre><code class="cmd">sudo ./linux_hardening.sh</code></pre>
        </li>
        <li>Post-checks (verify):
          <pre><code class="cmd">sudo sshd -t
sudo cat /etc/ssh/sshd_config | egrep "PermitRootLogin|PasswordAuthentication|Banner|Ciphers|MACs"
sudo cat /etc/issue.net
sudo ufw status || sudo firewall-cmd --list-all
ls -la /root/hardening_backups_*
sudo less /var/log/linux_hardening_*.log</code></pre>
        </li>
        <li>If anything goes wrong — restore:
          <pre><code class="cmd">sudo ./hardening_undo.sh</code></pre>
        </li>
      </ol>
    </section>

    <section>
      <h2>⚠️ Important notes &amp; warnings</h2>
      <ul>
        <li>Before disabling password authentication, ensure at least one admin has working SSH key access or you may get locked out.</li>
        <li>Test the script on a staging VM before running on production servers.</li>
        <li>The script creates backups — always review backups before wide rollout.</li>
        <li>Do not run with <code>--dry-run</code> only; preview first, then apply deliberately.</li>
      </ul>
    </section>

    <section>
      <h2>🛡️ What this script hardens (quick summary)</h2>
      <div class="pill">SSH</div>
      <div class="pill">Password Policy</div>
      <div class="pill">Firewall</div>
      <div class="pill">Kernel (sysctl)</div>
      <div class="pill">Fail2Ban</div>
      <p style="margin-top:12px;color:var(--muted)">These steps reduce common attack vectors like brute-force attacks, weak passwords, and unsecured services — making your server closer to industry best-practices.</p>
    </section>

    <section>
      <h2>📝 README — Quick changelog / Update</h2>
      <ul>
        <li>Initial release: advanced hardening script with dry-run and backup support</li>
        <li>Includes <code>hardening_undo.sh</code> to restore backed up config files</li>
      </ul>
    </section>

    <footer>
      <p>Author: <strong>Anant Laghane</strong> — 30 Days Linux Challenge · Day 2</p>
      <p style="font-size:13px;color:var(--muted)">Tip: Commit this <code>README.html</code> alongside your scripts so reviewers can open it directly in a browser.</p>
    </footer>
  </div>
</body>
</html>


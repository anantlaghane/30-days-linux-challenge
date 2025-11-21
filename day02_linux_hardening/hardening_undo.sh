#!/bin/bash
# hardening_undo.sh
# Restore the most recent backup directory created by linux_hardening.sh
set -euo pipefail

LATEST_DIR=$(ls -d /root/hardening_backups_* 2>/dev/null | tail -n1 || true)
if [ -z "$LATEST_DIR" ]; then
  echo "No backups found in /root/hardening_backups_*"
  exit 1
fi

echo "Found backup: $LATEST_DIR"
read -p "Proceed to restore files from this backup? (y/N): " ans
ans=${ans:-N}
if [[ ! "$ans" =~ ^[Yy]$ ]]; then
  echo "Aborting."
  exit 0
fi

# Restore files (preserve permissions)
echo "Restoring..."
cp -a "${LATEST_DIR}/etc/ssh/sshd_config" /etc/ssh/sshd_config || true
cp -a "${LATEST_DIR}/etc/issue.net" /etc/issue.net || true
cp -a "${LATEST_DIR}/etc/login.defs" /etc/login.defs || true
cp -a "${LATEST_DIR}/etc/pam.d/common-password" /etc/pam.d/common-password || true
cp -a "${LATEST_DIR}/etc/security/pwquality.conf" /etc/security/pwquality.conf || true
cp -a "${LATEST_DIR}/etc/pam.d/system-auth" /etc/pam.d/system-auth || true

echo "Restores complete. Please run: sudo sshd -t && sudo systemctl restart sshd (or use service restart) if appropriate."


#!/bin/bash
#
# linux_hardening.sh
# Day 2 — Advanced Linux Hardening (safe, idempotent, dry-run)
#
# Usage:
#   sudo ./linux_hardening.sh --dry-run   # preview only
#   sudo ./linux_hardening.sh             # apply changes
#
set -euo pipefail

# ---------- config ----------
DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then DRY_RUN=true; fi

timestamp() { date +"%F_%H%M%S"; }
BACKUP_DIR="/root/hardening_backups_$(timestamp)"
LOG="/var/log/linux_hardening_$(timestamp).log"

MAYBE_RUN() {
  if $DRY_RUN; then
    echo "[DRY-RUN] $*"
  else
    eval "$@"
  fi
}

log() { echo "$(date +"%F %T") : $*" | tee -a "$LOG"; }

require_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Run as root (sudo $0)"; exit 1
  fi
}

backup_file() {
  local f="$1"
  if [ -e "$f" ]; then
    mkdir -p "$BACKUP_DIR$(dirname "$f")"
    cp -a "$f" "$BACKUP_DIR$f"
    log "Backed up $f -> $BACKUP_DIR$f"
  fi
}

detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
    DISTRO_LIKE="${ID_LIKE:-}"
  else
    DISTRO="$(uname -s)"
    DISTRO_LIKE=""
  fi
  log "Detected distro: $DISTRO (like: $DISTRO_LIKE)"
}

set_config_option() {
  # file key value
  local file="$1" key="$2" val="$3"
  backup_file "$file"
  if grep -q -E "^[#[:space:]]*${key}[[:space:]]+" "$file" 2>/dev/null; then
    if $DRY_RUN; then
      echo "[DRY-RUN] sed -ri \"s|^[#[:space:]]*${key}[[:space:]]+.*|${key} ${val}|g\" $file"
    else
      sed -ri "s|^[#[:space:]]*${key}[[:space:]]+.*|${key} ${val}|g" "$file"
    fi
  else
    if $DRY_RUN; then
      echo "[DRY-RUN] echo \"${key} ${val}\" >> $file"
    else
      echo "${key} ${val}" >> "$file"
    fi
  fi
  log "Set $key in $file to $val"
}

# SSH banner
write_banner() {
  local banner_file="/etc/issue.net"
  local msg="$1"
  backup_file "$banner_file"
  if $DRY_RUN; then
    echo "[DRY-RUN] Write banner to $banner_file : $msg"
  else
    printf "%s\n" "$msg" > "$banner_file"
    chmod 644 "$banner_file"
  fi
  set_config_option "/etc/ssh/sshd_config" "Banner" "$banner_file"
  log "Banner written and configured"
}

# PAM pwquality / pwquality.conf
configure_pwquality() {
  local conf="/etc/security/pwquality.conf"
  backup_file "$conf"
  if $DRY_RUN; then
    echo "[DRY-RUN] Update pwquality.conf: minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1"
  else
    mkdir -p "$(dirname "$conf")"
    # ensure settings exist or append
    awk -v min="minlen=10" -v u="ucredit=-1" -v l="lcredit=-1" -v d="dcredit=-1" -v o="ocredit=-1" '
      BEGIN { seenmin=seenu=seenl=seend=seeno=0 }
      { if ($1=="minlen") { $0=min; seenmin=1 }
        if ($1=="ucredit") { $0=u; seenu=1 }
        if ($1=="lcredit") { $0=l; seenl=1 }
        if ($1=="dcredit") { $0=d; seend=1 }
        if ($1=="ocredit") { $0=o; seeno=1 }
        print }
      END {
        if (!seenmin) print min
        if (!seendu) print u
        if (!seenl) print l
        if (!seend) print d
        if (!seeno) print o
      }' "$conf" > "$conf.tmp" && mv "$conf.tmp" "$conf"
    log "Updated $conf"
  fi

  # Ensure pam_pwquality referenced in common-password or system-auth
  if [ -f /etc/pam.d/common-password ]; then
    local pamf="/etc/pam.d/common-password"
    backup_file "$pamf"
    if $DRY_RUN; then
      echo "[DRY-RUN] Ensure pam_pwquality line exists in $pamf"
    else
      if grep -q "pam_pwquality" "$pamf"; then
        sed -ri 's/(pam_pwquality.so).*/\1 retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' "$pamf" || true
      else
        sed -ri '/pam_unix.so/ i\password    requisite   pam_pwquality.so retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1' "$pamf" || true
      fi
    fi
    log "Ensured pam_pwquality in $pamf"
  elif [ -f /etc/pam.d/system-auth ]; then
    local pamf2="/etc/pam.d/system-auth"
    backup_file "$pamf2"
    if $DRY_RUN; then
      echo "[DRY-RUN] Ensure pam_pwquality in $pamf2"
    else
      if grep -q "pam_pwquality" "$pamf2"; then
        sed -ri 's/(pam_pwquality.so).*/\1 retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' "$pamf2" || true
      else
        sed -ri '/pam_unix.so/ i\password    requisite   pam_pwquality.so retry=3 minlen=10 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1' "$pamf2" || true
      fi
    fi
    log "Ensured pam_pwquality in $pamf2"
  fi
}

enable_firewall() {
  if command -v ufw >/dev/null 2>&1; then
    log "Configuring ufw"
    MAYBE_RUN "ufw default deny incoming"
    MAYBE_RUN "ufw default allow outgoing"
    MAYBE_RUN "ufw allow OpenSSH || ufw allow 22/tcp"
    MAYBE_RUN "ufw --force enable"
  elif command -v firewall-cmd >/dev/null 2>&1; then
    log "Configuring firewalld"
    MAYBE_RUN "systemctl enable --now firewalld || true"
    MAYBE_RUN "firewall-cmd --permanent --add-service=ssh || firewall-cmd --permanent --add-port=22/tcp || true"
    MAYBE_RUN "firewall-cmd --reload || true"
  else
    log "No firewall tool (ufw/firewalld) found; skipping firewall step"
  fi
}

set_sysctl_hardening() {
  local sysctl_file="/etc/sysctl.d/99-hardening.conf"
  backup_file "$sysctl_file"
  if $DRY_RUN; then
    echo "[DRY-RUN] Write sysctl hardening file $sysctl_file"
  else
    cat > "$sysctl_file" <<EOF
# Basic network/kernel hardening (added by linux_hardening.sh)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.log_martians = 1
net.ipv6.conf.all.disable_ipv6 = 1
EOF
    sysctl --system >/dev/null 2>&1 || true
  fi
  log "Applied sysctl hardening (99-hardening.conf)"
}

safe_restart_sshd() {
  # test sshd config before restart
  if command -v sshd >/dev/null 2>&1; then
    if $DRY_RUN; then
      echo "[DRY-RUN] sshd -t (syntax check)"
    else
      if ! sshd -t; then
        log "ERROR: sshd syntax check failed; aborting sshd restart"
        return 1
      fi
    fi
  fi

  if systemctl list-units --type=service 2>/dev/null | grep -q -E "sshd|ssh.service"; then
    MAYBE_RUN "systemctl restart sshd || systemctl restart ssh || true"
    log "Restarted sshd via systemctl"
  else
    MAYBE_RUN "service ssh restart || service sshd restart || true"
    log "Restarted sshd via service"
  fi
}

disable_unnecessary_services() {
  # Edit list per environment — these are common extras
  local services=( "avahi-daemon" "cups" "bluetooth" "rpcbind" "nfs-server" )
  for s in "${services[@]}"; do
    if systemctl list-unit-files --type=service | grep -q "^${s}"; then
      MAYBE_RUN "systemctl disable --now ${s} || true"
      log "Disabled service if present: $s"
    fi
  done
}

install_fail2ban() {
  if $DRY_RUN; then
    echo "[DRY-RUN] Install/configure fail2ban (recommended)"
  else
    if command -v apt >/dev/null 2>&1; then
      apt update -y && apt install -y fail2ban || true
    elif command -v yum >/dev/null 2>&1; then
      yum install -y epel-release || true
      yum install -y fail2ban || true
    fi
    # basic jail.local
    if [ -d /etc/fail2ban ]; then
      backup_file /etc/fail2ban/jail.local
      cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = ssh
maxretry = 5
bantime = 600
EOF
      systemctl enable --now fail2ban || true
      log "Installed and configured fail2ban (basic sshd jail)"
    fi
  fi
}

# ---------- main ----------
require_root
detect_distro
log "Starting Linux hardening (dry-run=$DRY_RUN)"
mkdir -p "$BACKUP_DIR"

# Backup important files
FILES=( "/etc/ssh/sshd_config" "/etc/issue.net" "/etc/login.defs" "/etc/pam.d/common-password" "/etc/security/pwquality.conf" "/etc/pam.d/system-auth" )
for f in "${FILES[@]}"; do backup_file "$f"; done

# 1) SSH hardening - basic + advanced choices
set_config_option "/etc/ssh/sshd_config" "PermitRootLogin" "no"
set_config_option "/etc/ssh/sshd_config" "PasswordAuthentication" "no"
set_config_option "/etc/ssh/sshd_config" "PermitEmptyPasswords" "no"
set_config_option "/etc/ssh/sshd_config" "ChallengeResponseAuthentication" "no"
set_config_option "/etc/ssh/sshd_config" "X11Forwarding" "no"
# Stronger ciphers/MACs (optional but recommended)
set_config_option "/etc/ssh/sshd_config" "Ciphers" "aes256-ctr,aes192-ctr,aes128-ctr"
set_config_option "/etc/ssh/sshd_config" "MACs" "hmac-sha2-512,hmac-sha2-256"
# You can uncomment or edit AllowUsers line as needed rather than forcing it:
# set_config_option "/etc/ssh/sshd_config" "AllowUsers" "admin ubuntu devops"

# 2) SSH banner
BANNER="WARNING: Unauthorized access is prohibited. Access is monitored and logged."
write_banner "$BANNER"

# 3) Password policy: pwquality + login.defs minimal settings
configure_pwquality
set_config_option "/etc/login.defs" "PASS_MAX_DAYS" "60"
set_config_option "/etc/login.defs" "PASS_MIN_DAYS" "1"
set_config_option "/etc/login.defs" "PASS_WARN_AGE" "7"

# 4) sysctl hardening (kernel/network)
set_sysctl_hardening

# 5) Firewall
enable_firewall

# 6) disable common unused services
disable_unnecessary_services

# 7) install basic fail2ban (optional)
install_fail2ban

# 8) safe restart sshd
safe_restart_sshd || log "Warning: sshd restart returned non-zero"

log "Hardening finished (dry-run=$DRY_RUN)"
echo
echo "HARDENING SCRIPT FINISHED. dry-run=$DRY_RUN"
echo "Log: $LOG"
if ! $DRY_RUN; then
  echo "Backups stored at: $BACKUP_DIR"
fi


#!/bin/bash

LOGFILE="threat_log.txt"
exec > >(tee -a "$LOGFILE") 2>&1

echo "======================"
echo "Threat Scan at $(date)"
echo "======================"

# 1. Suspicious process scan
SUSPICIOUS_PROCESSES=("nc" "nmap" "tcpdump" "hydra")
echo -e "\n Checking suspicious processes..."
for proc in "${SUSPICIOUS_PROCESSES[@]}"; do
    if pgrep -x "$proc" > /dev/null; then
        echo "⚠  Suspicious process '$proc' is running!"
    else
        echo " $proc not found."
    fi
done

# 2. Failed login attempts
echo -e "\n Checking failed login attempts..."
if [[ -f /var/log/auth.log ]]; then
    LOG_FILE="/var/log/auth.log"
elif [[ -f /var/log/secure ]]; then
    LOG_FILE="/var/log/secure"
else
    echo " No authentication log file found!"
    LOG_FILE=""
fi

if [[ -n "$LOG_FILE" ]]; then
    FAILED_LOGINS=$(sudo grep "Failed password" "$LOG_FILE" | grep "$(date --date='1 hour ago' '+%b %e %H')" | wc -l)
    echo "Failed logins in last hour: $FAILED_LOGINS"
fi

# 3. CPU load
echo -e "\n Checking CPU Load..."
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1 | tr -d ' ')
THRESHOLD=1.0
echo "Current CPU load: $LOAD"
if command -v bc >/dev/null 2>&1; then
    if (( $(echo "$LOAD > $THRESHOLD" | bc -l) )); then
        echo "⚠  High CPU load detected!"
    else
        echo " CPU load is normal."
    fi
else
    echo "⚠  'bc' not installed. Skipping CPU load check."
fi

# 4. Open ports
echo -e "\n🌐 Listing open network ports..."
ss -tuln | grep LISTEN || echo "No open ports found."

# 5. Shutdown/Reboot events
echo -e "\n⚡ Checking recent shutdown/reboot events..."
if command -v last >/dev/null 2>&1; then
    last -x | grep -E "shutdown|reboot" | head -5
else
    echo "⚠  'last' command not found, using syslog fallback..."
    if [[ -f /var/log/syslog ]]; then
        grep -Ei 'shutdown|reboot|poweroff' /var/log/syslog | tail -n 5
    else
        echo " Could not find /var/log/syslog to extract shutdown logs."
    fi
fi

# 6. Error log scan
echo -e "\n Scanning system logs for errors..."
if [[ -f /var/log/syslog ]]; then
    grep -iE "error|fail|critical|panic" /var/log/syslog | tail -n 10 || echo "No critical errors found."
elif [[ -f /var/log/messages ]]; then
    grep -iE "error|fail|critical|panic" /var/log/messages | tail -n 10 || echo "No critical errors found."
else
    echo "⚠  No system error log file found."
fi

# 7. End of scan
echo -e "\n Scan completed at $(date)"
echo "------------------------------------"

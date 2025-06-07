# Threat Detection Tool

A simple Bash script for basic threat detection on Linux systems.  
It checks for suspicious processes, failed login attempts, CPU load, open network ports, recent shutdown/reboot events, and system log errors.

---

## Features

- Detects suspicious processes related to common hacking tools  
- Counts failed login attempts in the last hour  
- Monitors CPU load and warns if it's high  
- Lists open network ports  
- Checks for recent shutdown or reboot events  
- Scans system logs for errors

---

## Usage

Run the script with sudo for proper permissions:

```bash
sudo bash Detect.sh

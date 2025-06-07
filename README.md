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
sudo bash Detect.sh ```

```
Dependencies / Requirements

Your script uses these standard Linux commands:

   grep

   awk

  last (for login and shutdown info)

  netstat or ss (to list open network ports)

  bc (for floating point CPU load comparison)

  ps (for process checks)

  uptime (to get CPU load) 

  What if some commands are missing?

   On Debian/Ubuntu systems:

     sudo apt install net-tools procps bc

  On Fedora/CentOS/RHEL:

    sudo dnf install net-tools procps-ng bc


Notes:

 Some commands like last may not be installed by default on minimal systems.

 netstat is part of the net-tools package; some distros prefer ss from iproute2.

 Your script currently falls back if some commands are missing, but installing these ensures full functionality.
```

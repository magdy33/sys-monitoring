Memory, CPU, and Disk Monitoring Script with Email Alerts
This project monitors the memory, CPU, and disk usage on a Linux machine and sends an email alert if any of the system resources exceed a defined threshold. It uses s-nail for sending emails and cron to automate the process.

Prerequisites
A Linux system (RHEL 9 or similar)
s-nail for sending emails
A Gmail account with 2-Step Verification and App Password enabled for email configuration
Cron to schedule the monitoring script

Steps to Setup
1. Install s-nail on your system
Enable the required repository:

```bash
subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
Update packages:
```

```bash
dnf update -y
```

Install s-nail:

```bash
dnf install -y s-nail
```

2. Configure s-nail for Email Notifications
Enable 2-Step Verification and generate an App Password in your Google Account Security Settings.

![P2](snippet/Screenshot(683).png)

Configure s-nail:

Open the configuration file:

```bash
vim ~/.mailrc
```

Add the following configuration:

```bash
set mta="smtp://smtp.gmail.com:587"
set smtp-auth=login
set smtp-auth-user="your-email@gmail.com"
set smtp-auth-password="APP_PASSWORD"   # Replace with the App Password
set from="your-email@gmail.com"
set ssl-verify=ignore
set smtp-use-starttls
```

![P5](snippet/Screenshot(686).png)


Note: Replace APP_PASSWORD with the password you generated in your Google account.

![P4](snippet/Screenshot(685).png)

3. Create the Monitoring Script (free_mem.sh)
Create the script:

```bash
vim /path/to/yourscript
```
Add the following script content:

```bash
#!/bin/bash

# Memory check
mem=$(free -mt | grep Total | awk '{print $4}')
if [ $mem -le 1500 ]; then
    echo "Memory is low: More than 80% of memory is consumed." | s-nail -s "Warning: Low Memory" your-email@gmail.com
fi

# CPU usage check
cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if [ $(echo "$cpu > 80" | bc) -eq 1 ]; then
    echo "CPU usage is high: $cpu%" | s-nail -s "Warning: High CPU Usage" your-email@gmail.com
fi

# Disk usage check
disk=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $disk -ge 90 ]; then
    echo "Disk usage is high: $disk%" | s-nail -s "Warning: High Disk Usage" your-email@gmail.com
fi
```

This script checks for:

Memory: If the memory usage exceeds 80% (1500MB threshold), an email is sent.
CPU: If the CPU usage exceeds 80%, an email is sent.
Disk: If the disk usage exceeds 90%, an email is sent.
Make the script executable:

```bash
chmod +x /path/to/yourscript
```
4. Setup Cron Job for Periodic Execution
Open the cron job file:

```bash
crontab -e
```
Add the following cron job to execute the script every hour:

```bash
0 * * * * /path/to/yourscript
```
This cron job will run the script at the beginning of every hour.

Testing and Verification
Test the script manually:

```bash
/path/to/yourscript
```

Check your email to verify if you receive the alert when memory, CPU, or disk usage exceeds the set thresholds.

![P6](snippet/Screenshot(687).png)

Verify the cron job: To confirm that the cron job is set up correctly, run:

```bash
crontab -l
```

Author 
Magdi Abdelfattah

#!/bin/bash



# Memory usage check
mem=$(free -m | awk '/Mem:/ {print $3/$2 * 100.0}')
if [ $(echo "$mem > 80" | bc) -eq 1 ]; then
    echo "Memory usage is high: $mem%" | s-nail -s "Warning: High Memory Usage" magdiabdelfattah3@gmail.com
fi

# CPU usage check
cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if [ $(echo "$cpu > 50" | bc) -eq 1 ]; then
    echo "CPU usage is high: $cpu%" | s-nail -s "Warning: High CPU Usage" magdiabdelfattah3@gmail.com
fi

# Disk usage check
disk=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $disk -ge 10 ]; then
    echo "Disk usage is high: $disk%" | s-nail -s "Warning: High Disk Usage" magdiabdelfattah3@gmail.com
fi

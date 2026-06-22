#!/bin/bash
# Temperature Monitoring Script
# Monitors CPU and GPU temperatures and sends alerts

# Configuration
CPU_TEMP_WARNING=75
CPU_TEMP_CRITICAL=85
GPU_TEMP_WARNING=75
GPU_TEMP_CRITICAL=85
CHECK_INTERVAL=30  # Check every 30 seconds

# Track notification state
NOTIFIED_CPU_WARN=false
NOTIFIED_CPU_CRIT=false
NOTIFIED_GPU_WARN=false
NOTIFIED_GPU_CRIT=false

while true; do
    # Get CPU temperature (average of all cores)
    CPU_TEMP=$(sensors | grep -i 'Package id 0:\|Tdie:' | awk '{print $4}' | sed 's/+//;s/°C//' | head -1)
    
    # If Package id not found, try other methods
    if [ -z "$CPU_TEMP" ]; then
        CPU_TEMP=$(sensors | grep -i 'Core 0:' | awk '{print $3}' | sed 's/+//;s/°C//' | head -1)
    fi
    
    # Get GPU temperature (if available)
    GPU_TEMP=$(sensors | grep -i 'edge:\|temp1:' | awk '{print $2}' | sed 's/+//;s/°C//' | head -1)
    
    # Check CPU temperature
    if [ -n "$CPU_TEMP" ]; then
        CPU_TEMP_INT=${CPU_TEMP%.*}
        
        if [ "$CPU_TEMP_INT" -ge "$CPU_TEMP_CRITICAL" ]; then
            if [ "$NOTIFIED_CPU_CRIT" = false ]; then
                notify-send -u critical -i temperature-high "Critical CPU Temperature" "CPU temperature is ${CPU_TEMP}°C! System may throttle or shutdown."
                NOTIFIED_CPU_CRIT=true
                NOTIFIED_CPU_WARN=true
            fi
        elif [ "$CPU_TEMP_INT" -ge "$CPU_TEMP_WARNING" ]; then
            if [ "$NOTIFIED_CPU_WARN" = false ]; then
                notify-send -u normal -i temperature-normal "High CPU Temperature" "CPU temperature is ${CPU_TEMP}°C"
                NOTIFIED_CPU_WARN=true
            fi
        else
            NOTIFIED_CPU_WARN=false
            NOTIFIED_CPU_CRIT=false
        fi
    fi
    
    # Check GPU temperature
    if [ -n "$GPU_TEMP" ]; then
        GPU_TEMP_INT=${GPU_TEMP%.*}
        
        if [ "$GPU_TEMP_INT" -ge "$GPU_TEMP_CRITICAL" ]; then
            if [ "$NOTIFIED_GPU_CRIT" = false ]; then
                notify-send -u critical -i temperature-high "Critical GPU Temperature" "GPU temperature is ${GPU_TEMP}°C!"
                NOTIFIED_GPU_CRIT=true
                NOTIFIED_GPU_WARN=true
            fi
        elif [ "$GPU_TEMP_INT" -ge "$GPU_TEMP_WARNING" ]; then
            if [ "$NOTIFIED_GPU_WARN" = false ]; then
                notify-send -u normal -i temperature-normal "High GPU Temperature" "GPU temperature is ${GPU_TEMP}°C"
                NOTIFIED_GPU_WARN=true
            fi
        else
            NOTIFIED_GPU_WARN=false
            NOTIFIED_GPU_CRIT=false
        fi
    fi
    
    sleep "$CHECK_INTERVAL"
done

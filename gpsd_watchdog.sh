#!/bin/bash

LOG_FILE="/etc/pwnagotchi/log/pwnagotchi.log"
SEARCH_STRING="GPSD connection closed"
DEVICE_MAC="<PHONE_BT_MAC>"  # Replace with your device's MAC address

while true; do
    if ! bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        echo "$(date): Device $DEVICE_MAC not connected. Attempting to reconnect..." >> /var/log/gpsd_watchdog.log
        bluetoothctl connect "$DEVICE_MAC"
	    sleep 5
    fi

    if tail -n 5 "$LOG_FILE" | grep -q "$SEARCH_STRING"; then
        echo "$(date): Detected GPSD issue, restarting gpsd..." >> /var/log/gpsd_watchdog.log
        systemctl restart gpsd
        # Optional: clear the log to avoid repeated restarts
        #sed -i "/$SEARCH_STRING/d" "$LOG_FILE"
    fi
    sleep 30
done

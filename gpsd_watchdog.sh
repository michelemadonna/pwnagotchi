#!/bin/bash

LOG_FILE="/etc/pwnagotchi/log/pwnagotchi.log"
SEARCH_STRING="GPSD connection closed"
DEVICE_MAC="PHONE_BT_MAC"  # Replace with your device's MAC address
LOG_FILE_WATCHDOG="/var/log/gpsd_watchdog.log"
PHONE_IP="PHONE_BT_IP"  # Replace with your phone's IP address
PHONE_NETWORK_NAME="PHONE_BT_NETWORK_NAME"  # Replace with your phone's network name

log_info() {
    local message="$1"
    local thread="Thread-1"
    local timestamp
    timestamp=$(date +"[%Y-%m-%d %H:%M:%S,%3N]")
    printf "%s [INFO] [%s] : [GPSD-Whatchdog][Thread] %s\n" "$timestamp" "$thread" "$message"
}

log_command() {
    local cmd="$1"
    local timestamp
    timestamp=$(date +"[%Y-%m-%d %H:%M:%S,%3N]")
    echo "$timestamp [INFO] [Thread-$THREAD_ID] : [GPSD-ng][Thread] Running: $cmd" >> "$LOG_FILE_WATCHDOG"

    # Execute the command and log each line of output
    eval "$cmd" 2>&1 | while IFS= read -r line; do
        timestamp=$(date +"[%Y-%m-%d %H:%M:%S,%3N]")
        echo "$timestamp [INFO] [Thread-$THREAD_ID] : [GPSD-ng][Thread] $line" >> "$LOG_FILE_WATCHDOG"
    done
}

check_connection() {
    local gateway=$1
    ping -c 1 "$gateway" > /dev/null 2>&1
    return $?
}

while true; do
     sleep 60
     if bluetoothctl info "$DEVICE_MAC" | grep -q "Connected: yes"; then
        if ! check_connection "$PHONE_IP"; then
                log_info "Connection to gateway $PHONE_IP failed. Reconnecting to $PHONE_NETWORK_NAME..." >> /etc/pwnagotchi/log/pwnagotchi.log #/var/log/gpsd_watchdog.log
                #log_command "bluetoothctl disconnect $DEVICE_MAC"
                #sleep 3
                #log_command "nmcli device disconnect $DEVICE_MAC"
                
                #sleep 1
                log_command "nmcli connection up '$PHONE_NETWORK_NAME'"
                sleep 5
        fi


        if tail -n 5 "$LOG_FILE" | grep -q "$SEARCH_STRING"; then
                log_info "Detected GPS-D issue, restarting gpsd..." >> /etc/pwnagotchi/log/pwnagotchi.log #/var/log/gpsd_watchdog.log
                systemctl restart gpsd
        fi
    else
        log_command "bluetoothctl info $DEVICE_MAC"
        log_command "nmcli device"
        log_command "nmcli connection"
        log_command "ip a"
    fi

    if tail -n 1 "$LOG_FILE" | grep -i -v "gpsd" | grep -q "handshakes will be collected inside"; then
        systemctl restart pwnagotchi
    fi

done
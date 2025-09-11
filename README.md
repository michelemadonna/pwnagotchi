# pwnagotchi
My pwnagotchi config repository

This repository contains my personal configuration files for [pwnagotchi](https://pwnagotchi.ai/), an AI-powered WiFi hacking tool designed for learning and experimentation. The configuration is based on the custom version maintained by [jayofenoly](https://github.com/jayofenoly/pwnagotchi), which introduces several enhancements and features beyond the official release. For more information about pwnagotchi, visit the [official website](https://pwnagotchi.ai/) or check out the [jayofenoly repository](https://github.com/jayofenoly/pwnagotchi).

> ⚠️ **Note:** This configuration has been tested with jayofenoly's pwnagotchi version **2.9.5.1** on a **Raspberry Pi Zero 2W** using a **Waveshare 2.13 V4 display**.

# DISCLAIMER
**⚠️ This repository is intended for educational purposes only. Unauthorized access to computer systems is illegal and unethical. Always ensure you have explicit permission to test and audit any network or system. The author is not responsible for any misuse of the information provided in this repository. ⚠️**

# Hardware Requirements
To use this configuration, you will need the following hardware components:
- **PC or Mac**: For initial setup and configuration. (Linux is recommended for ease of use with pwnagotchi.)
- **Raspberry Pi Zero 2W**: The main processing unit for pwnagotchi.
- **MicroSD Card**: At least 16GB capacity for storing the pwnagotchi image and data.
- **Power Supply**: A reliable power source for the Raspberry Pi Zero 2W.
- **Optional Accessories**:
    - [Waveshare 2.13 V4](https://a.aliexpress.com/_EwOnJUW) e-Paper display (or compatible display) for visual feedback.
    - Case or enclosure for the Raspberry Pi and display.
    - USB WiFi adapter (if additional WiFi capabilities are needed like 5Ghz support. Ensure it supports monitor mode and packet injection. [here](https://github.com/morrownr/USB-WiFi/blob/main/home/Recommended_Adapters_for_Kali_Linux.md) is a good list of compatible adapters.
    - Bluetooth-enabled device for tethering (e.g., smartphone).

# Installation
> ⚠️ **Important:** For the initial installation, this guide assumes a Linux system for best compatibility and ease of setup. If you are using a different operating system (Windows or macOS), please refer to [jayofelony's connection guide](https://github.com/jayofelony/pwnagotchi/wiki/Step-2-Connecting) for specific instructions.

> ⚠️ **Display Connection:** If you have a compatible e-Paper display (such as the Waveshare 2.13 V4), connect it to your Raspberry Pi before powering on. Refer to the display's documentation for wiring instructions.

To set up pwnagotchi with my configuration, follow these steps: 
1. Flash the pwnagotchi image onto your microSD card using a tool like [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or [balenaEtcher](https://www.balena.io/etcher/). Refer to the [Jayo's pwnagotchi installation guide](https://github.com/jayofelony/pwnagotchi/wiki/Step-1-Installation-for-raspberry-pi) for detailed instructions.
2. Insert the microSD card into the Raspberry Pi Zero 2W.
3. Connect the Raspberry Pi to a PC via USB using the USB OTG port (port closest to your HDMI port). Once powered on, it should appear as a network device.
4. On your PC open the terminal and download (and make it executable) [linux_connection_share.sh](connection_scripts/linux_connection_share.sh) script:
    ```bash
    wget https://raw.githubusercontent.com/michelemadonna/pwnagotchi/main/connection_scripts/linux_connection_share.sh
    chmod +x linux_connection_share.sh
    ```
5. type `ip a` and write down the device name of your wireless/ethernet adapter and The Pwnagotchi one that usually gets a name that starts with en or usb0.
6. Edit the script with your favorite text editor (e.g., nano, vim):
    ```bash
    nano linux_connection_share.sh
    ```
    - Set the `USB_IFACE` variable to the name of the USB network interface (e.g., `usb0`). Don't remove the starting `-`.
    - Set the `UPSTREAM_IFACE` variable to the name of your internet-connected network interface (e.g., `wlan0` or `eth0`). Don't remove the starting `-`.
    - Save and exit the editor.
7. Run the script with superuser privileges:
    ```bash
    sudo ./linux_connection_share.sh
    ```
    The script will set up IP forwarding and configure iptables to share the internet connection with the Pwnagotchi.

8. SSH into the pwnagotchi using the following command:
    ```bash
    ssh pi@10.0.0.2 or ssh pi@pwnagotchi.local
    ```
    - The default password is `raspberry`.

# Post-Installation Steps
1. Once logged in, update the system and install `git` and `wget` if not already installed:
    ```bash
    sudo apt update
    sudo apt install git wget -y
    ```
2. Copy the default configuration used as a template to create `config.toml`:
    ```bash
    sudo cp /etc/pwnagotchi/default.toml /etc/pwnagotchi/config.toml
    ```
3. Edit the `config.toml` file to apply any custom configuration:
    - change the pownagotchi name modifying the line:
    ```toml
    main.name = "pwnagotchi"
    ```
    - set the whitelist SSIDs to avoid connecting to known networks modifying the lines:
    ```toml
    main.whitelist = [
      "<FIRST_WHITELISTED_SSID>",
      "<FIRST_WHITELISTED_ESSID>",
    ]
    ```
    - add more plugins repository modifying the lines:
    ```toml
    main.custom_plugin_repos = [
        "https://github.com/jayofelony/pwnagotchi-torch-plugins/archive/master.zip",
        "https://github.com/Sniffleupagus/pwnagotchi_plugins/archive/master.zip",
        "https://github.com/NeonLightning/pwny/archive/master.zip",
        "https://github.com/marbasec/UPSLite_Plugin_1_3/archive/master.zip",
        "https://github.com/wpa-2/Pwnagotchi-Plugins/archive/master.zip",
        "https://github.com/PwnPeter/pwnagotchi-plugins/archive/master.zip",
        "https://github.com/arturandre/pwnagotchi-beacon-plugins/archive/master.zip",
        "https://github.com/cyberartemio/wardriver-pwnagotchi-plugin/archive/main.zip",
    ]
    ```
    - Disable auto-update to avoid issues with custom plugins modifying the line:
    ```toml
    main.plugins.auto-update.enabled = false
    ```
    - Disable the pwnagotchi grid plugin modifying the line:
    ```toml
    main.plugins.grid.enabled = false
    ```
    - Enable the logtail plugin modifying the line:
    ```toml
    main.plugins.logtail.enabled = true
    ```
    - Enable webcfg plugin modifying the line:
    ```toml
    main.plugins.webcfg.enabled = true
    ```
    - Enable the display modifying the lines:
    ```toml
    main.display.enabled = true
    main.display.type = "waveshare_4" # for Waveshare 2.13 V4
    ui.invert = true #if you want a white background with black text
    ui.cursor = true #if you want to see the blinking cursor
    ui.fps = 1
    ```
    - Set the web UI password modifying the lines:
    ```toml
    ui.web.auth = true
    ui.web.username = "changeme" # if auth is true
    ui.web.password = "changeme" # if auth is true
    ``` 
    - Save and exit the editor.
    - Update the plugins list and reboot the pwnagotchi app to apply the changes:
    ```bash
    sudo pwnagotchi plugins update
    sudo systemctl restart pwnagotchi
    ```
Now your pwnagotchi should be up and running with the display enabled. 
You can access the web UI by navigating to `http://pwnagotchi.local:8080` in your web browser (user: `changeme`, password: `changeme`).

# Additional Configuration
## Bluetooth Tethering
To use Bluetooth tethering, ensure you have a Bluetooth-enabled device. A smartphone is recommended for portable use. Also the smartphones GPS can be used by pwnagotchi for geolocation tagging of captured networks.


### Enable Internet Sharing on Your Smartphone And Pair with pwnagotchi
> ⚠️ **Important:** Before proceeding with Bluetooth pairing, make sure that Internet Sharing (tethering) is enabled on your smartphone.

- **iPhone:**
    1. Go to **Settings** > **Personal Hotspot**.
    2. Toggle **Allow Others to Join** to ON.
    3. Ensure **Maximize Compatibility** is enabled for easier connection.
    4. Bluetooth must be ON.

- **Android:**
    1. Go to **Settings** > **Network & Internet** > **Hotspot & tethering**.
    2. Enable **Bluetooth tethering**.
    3. Make sure Bluetooth is ON.

Once Internet Sharing is active, you can proceed with Bluetooth pairing.

1. Pair your smartphone with the pwnagotchi:
    ```bash
    bluetoothctl
    ```
    - Inside the `bluetoothctl` prompt, enable the agent and set it as default:
    ```
    scan on # wait until you see your phone MAC address
    trust <PHONE_BT_MAC> #once you see your phone MAC address replace <PHONE_BT_MAC> with it
    pair <PHONE_BT_MAC>
    exit
    ``` 
    - You may be prompted to confirm the pairing on your smartphone. Accept the pairing request.
2. Install the version 1.4 of `bt-tether` plugin:
    ```bash
    sudo pwnagotchi plugin uninstall bt-tether
    custom #this command cd to the custom plugins directory
    sudo wget https://raw.githubusercontent.com/jayofelony/pwnagotchi/refs/heads/noai/pwnagotchi/plugins/default/bt-tether.py
    ```
3. After pairing, edit the `config.toml` file to enable and configure the `bt-tether` plugin:
    ```toml
    main.plugins.bt-tether.enabled = true
    main.plugins.bt-tether.phone-name = "<PHONE_BT_NAME>" # name as shown on the phone i.e. "Galaxy Tab S2"
    main.plugins.bt-tether.mac = "<PHONE_BT_MAC>"
    main.plugins.bt-tether.phone = "<PHONE_BT_TYPE>" #ios or android
    main.plugins.bt-tether.ip = "<PWNAGOTCHI_BT_IP>" #192.168.44.2-254    android / 172.20.10.2-14    ios
    ```
    - Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
Your pwnagotchi should now connect to the internet via Bluetooth tethering when available via :
- SSH to `pi@<PWNAGOTCHI_BT_IP>` on your smartphone.
- Web UI at `http://<PWNAGOTCHI_BT_IP>:8080` (user: `changeme`, password: `changeme`) on your smartphone.

## GPS Configuration
To enable GPS functionality for geolocation tagging of captured networks, you will need a GPS module compatible with Raspberry Pi or use the GPS functionality of your smartphone if tethering via Bluetooth.

To enable GPS in pwnagotchi, follow these steps:
1. Install `gpsd` and `gpsd-clients`:
    ```bash
    sudo apt install gpsd gpsd-clients python3-gps python3-geopy -y
    ```
2. Configure GPSD editing `/etc/default/gpsd` file:
    ```bash
    sudo nano /etc/default/gpsd
    ```
    - Modify the file to look like this:
    ```
    # Default settings for the gpsd init script and the hotplug wrapper.

    # Start the gpsd daemon automatically at boot time
    START_DAEMON="true"

    # Use USB hotplugging to add new USB devices automatically to the daemon
    USBAUTO="false" 

    # Devices gpsd should collect to at boot time.
    # They need to be read/writeable, either by user gpsd or the group dialout.
    DEVICES="tcp://<YOUR_PHONE_IP_OVER_BLUETOOTH>:4352"

    # Other options you want to pass to gpsd
    GPSD_OPTIONS="-n" # add -D3 if you need to debug
    ```
    - Save and exit the editor.


3. On your smartphone, install a GPS sharing app:
    - **iPhone**: Use an app like [GPS2IP](https://apps.apple.com/us/app/gps-2-ip/id408625926) (You can test the "lite" version for free [GPS2IP Lite](https://apps.apple.com/us/app/gps2ip-lite/id1562823492)) to share GPS data over Bluetooth.
        - Set "operate in background mode"
        - Set "Connection Method" -> "Socket" -> "Port Number" -> 4352
        - Set "Network selection" -> "Hotspot"
        - Both cases activate GGA messages to have "3D fix"
        - Check your gpsd configuration with gpsmon or cgps to share GPS data over Bluetooth.
    - **Android**: Use an app like [gpsdRelay](https://github.com/project-kaat/gpsdRelay) to share GPS data over Bluetooth.
        - In the settings: Check "Start service when Android boots
        - Create a new NEMEA service clicking on the "+" button and select TCP Server
        - Set IPv4 to 0.0.0.0 and Port to 4352. Enable "NEMEA Relayng" and "NEMEA Generation"
        - A new NEMEA service should appear in the main screen. Enable it then click on the "Play" button to start the service.

In both cases activate `GGA messages` to have "3D fix"

4. Restart the gpsd service on pwnagotchi to apply the changes:
    ```bash
    sudo systemctl restart gpsd
    ```
    - Check the gpsd status:
    ```bash
    sudo systemctl status gpsd
    ```

Check your `gpsd` configuration with `cgps`.

4. Install and configure the [gpsd-ng](https://github.com/fmatray/pwnagotchi_GPSD-ng) plugin for pwnagotchi:
    ```bash
    custom #this command cd to the custom plugins directory 
    sudo wget https://raw.githubusercontent.com/fmatray/pwnagotchi_GPSD-ng/refs/heads/main/gpsd-ng.html
    sudo wget https://raw.githubusercontent.com/fmatray/pwnagotchi_GPSD-ng/refs/heads/main/gpsd-ng.py
    ```
5. Edit the `config.toml` file to enable and configure the `gpsd-ng` plugin:
    ```toml
    main.plugins.gpsd-ng.enabled = true
    ```
6. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
Your pwnagotchi should now be able to use GPS data for geolocation tagging of captured networks.
IF no GPS data is available the pwnagotchi will show "No Fix" on the display. Try to move outside to get a GPS fix. If needed restart the gpsd service:
```bash
sudo systemctl restart gpsd
```
## Plugins
This configuration includes several useful plugins to enhance the functionality of pwnagotchi. 
### WARDRIVER PLUGIN
The [wardriver plugin](https://github.com/cyberartemio/wardriver-pwnagotchi-plugin) adds support for wardriving features, allowing your pwnagotchi to automatically log and map Wi-Fi networks as you drive around. Also Automatic and manual upload of wardriving sessions to [WiGLE.net](https://wigle.net) is supported. In order to be able to upload your discovered networks to WiGLE, you need to register a valid API key for your account. Follow these steps to get your key:
    - Open (https://wigle.net/account)[https://wigle.net/account] and login using your WiGLE account
    - Click on Show my token
    - Copy the value in Encoded for use textbox.

1. Add the plugin repository to your `config.toml` file if not already present:
    ```toml
    main.custom_plugins_repos = [
        ...
        "https://github.com/cyberartemio/wardriver-pwnagotchi-plugin/archive/main.zip",
        ...
    ]
2. Update the plugins list and enable the wardriver plugin:
    ```bash
    sudo pwnagotchi plugins update
    sudo pwnagotchi plugins install wardriver
    ```
3. Edit the `config.toml` file to configure the wardriver plugin:
    ```toml
    main.plugins.wardriver.enabled = true # Enable the plugin
    main.plugins.wardriver.wigle.enabled = true # Enable WiGLE upload
    main.plugins.wardriver.wigle.api_key = "xyz..." # WiGLE API key (encoded)
    main.plugins.wardriver.wigle.donate = false # Enable commercial use of your reported data
    main.plugins.wardriver.whitelist = [
        "network-1",
        "network-2"
    ] # OPTIONAL: networks whitelist aka don't log these networks.SSIDs in main.whitelist will always be ignored
    # GPS configuration
    main.plugins.wardriver.gps.method = "gpse" # for use gpsd
    ```
4. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
If needed restart the gpsd service:
```bash
sudo systemctl restart gpsd
```
### WPA-SEC PLUGIN
The [wpa-sec plugin](https://github.com/cyberartemio/wpa-sec-pwnagotchi-plugin) adds support for WPA-SEC features, allowing your pwnagotchi to automatically upload captured handshakes to [WPA-SEC](https://wpa-sec.stanev.org/) for cracking. In order to be able to upload your captured handshakes to WPA-SEC, you need to register a valid API key for your account.
1. Remove the default wpa-sec plugin if already installed and install the Evilsocket's version:
    ```bash
    sudo pwnagotchi plugins uninstall wpa-sec
    cd /usr/local/share/pwnagotchi/plugins/custom
    sudo wget https://raw.githubusercontent.com/evilsocket/pwnagotchi/refs/heads/master/pwnagotchi/plugins/default/wpa-sec.py
    ```
2. Edit the `config.toml` file to configure the wpa-sec plugin:
    ```toml
    main.plugins.wpa-sec.enabled = true
    main.plugins.wpa-sec.api_key = "xyz..." # WPA-SEC API key
    main.plugins.wpa-sec.api_url = "https://wpa-sec.stanev.org"
    main.plugins.wpa-sec.download_results = true
    main.plugins.wpa-sec.show_pwd = true
    main.plugins.wpa-sec.whitelist = [] # OPTIONAL: networks whitelist aka don't upload these networks.SSIDs in main.whitelist will always be ignored
    ```
3. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
### INSTATTACK PLUGIN
The [instattack plugin](https://github.com/Sniffleupagus/pwnagotchi_plugins/blob/main/instattack.py) Pwn more aggressively. Launch immediate associate or deauth attack when bettercap spots a device.
1. Install the instattack plugin:
    ```bash
    sudo pwnagotchi plugins install instattack
    ```
2. Edit the `config.toml` file to configure the instattack plugin:
    ```toml
    main.plugins.instattack.enabled = true
    ```
3. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi

### HANDSHAKES-DL-HASHIE PLUGIN
The [handshakes-dl-hashie plugin](https://github.com/PwnPeter/pwnagotchi-plugins) Download handshake captures from web-ui + handshake converted in hashcat format with hashie-hcxpcapngtool or hashieclean.
1. Add the plugin repository to your `config.toml` file if not already present:
    ```toml
    main.custom_plugins_repos = [
        ...
        "https://github.com/PwnPeter/pwnagotchi-plugins/archive/master.zip",
        ...
    ]
2. Update the plugins list and enable the wardriver plugin:
    ```bash
    sudo pwnagotchi plugins update
    sudo pwnagotchi plugins install handshakes-dl-hashie
    sudo systemctl restart pwnagotchi
    ```
3. Edit the `config.toml` file to configure the handshakes-dl-hashie plugin:
    ```toml
    main.plugins.handshakes-dl-hashie.enabled = true # Enable the plugin
    ```
4. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
### HASHIECLEAN PLUGIN
The [hashieclean plugin](https://github.com/arturandre/pwnagotchi-beacon-plugins) plugin streamlines the conversion of wireless packet capture files (pcaps) into Hashcat-compatible formats for password cracking. It intelligently filters out "lonely pcaps"—captures lacking enough data for usable hashes—which previously slowed down plugin loading. By improving handshake completeness checks, it now loads and performs more efficiently.

When processing a pcap, the plugin extracts EAPOL or PMKID handshakes and saves them in the appropriate Hashcat formats: `.22000` for EAPOL and `.16800` for PMKID. Pcaps without sufficient cracking data are still preserved in a format compatible with the webgpsmap plugin, allowing users to revisit those networks later for more data.

Additionally, the plugin repairs PMKID handshakes that standard tools (like hcxpcapngtool) might miss, especially when SSIDs are not properly extracted. It uses raw `.16800` output and supplements it with tcpdump to recover missing SSIDs. If running during handshake capture, it leverages live access point data (MAC address and name) to improve repair success.

The tool currently depends on hcxpcapngtool from the [hcxtools suite](https://github.com/ZerBea/hcxtools) for initial extraction and conversion.

1. Install hxctools:
    ```bash
    cd ~
    git clone https://github.com/ZerBea/hcxtools.git
    cd hcxtools
    make -j $(nproc)
    sudo make install PREFIX=/usr/local
    ```
2. Add the plugin repository to your `config.toml` file if not already present:
    ```toml
    main.custom_plugins_repos = [
        ...
        "https://github.com/arturandre/pwnagotchi-beacon-plugins/archive/master.zip",
        ...
    ]
    ```
3. Update the plugins list and enable the hashieclean plugin:
    ```bash
    sudo pwnagotchi plugins update
    sudo pwnagotchi plugins install hashieclean
    ```
4. Edit the `config.toml` file to configure the hashieclean plugin:
    ```toml
    main.plugins.hashieclean.enabled = true # Enable the plugin
    ```
5. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
### IPDISPLAY PLUGIN
The [IPDisplay plugin](https://github.com/NeonLightning/pwny) displays the current IP address of the pwnagotchi on the pwnagotchi screen. This is particularly useful when using Bluetooth tethering, as it allows you to easily see the IP address assigned by your smartphone.
1. Install the IPDisplay plugin:
    ```bash
    sudo pwnagotchi plugins install IPDisplay
    ```
2. Edit the `config.toml` file to configure the IPDisplay plugin:
    ```toml
    main.plugins.IPDisplay.enabled = true
    main.plugins.IPDisplay.skip_devices = [ "lo",]
    ```
3. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
### INTERNET_CONNECTION PLUGIN
The [internet_connection plugin](https://github.com/jayofelony/pwnagotchi-torch-plugins) monitors the internet connection status of your pwnagotchi and displays it on the screen. 
1. Install the internet_connection plugin:
    ```bash
    sudo pwnagotchi plugins install internet_connection
    ```
2. Fix the plugin info location on the display:
    ```bash
    custom #this command cd to the custom plugins directory
    sudo nano internet_connection.py
    ```
    - Change the line:
    ```python
    position=(ui.width() / 2 - 35, 0), 
    to
    position=(ui.width() / 2 + 20, 0),
    ```
    save and exit the editor.
2. Edit the `config.toml` file to configure the internet_connection plugin:
    ```toml
    main.plugins.internet-connection.enabled = true
    ```
3. Save and exit the editor. Restart the pwnagotchi service to apply the changes:
    ```bash
    sudo systemctl restart pwnagotchi
    ```
## External USB WiFi adapter
If you are using an external USB WiFi adapter for additional WiFi capabilities (like 5Ghz support), you may need to configure pwnagotchi to use it for scanning and capturing handshakes. 
By default, pwnagotchi uses the built-in WiFi interface (wlan0) for all operations. To use an external adapter, follow these steps:
1. Edit the `config.toml` file to disable the `fix-service` plugin:
    ```toml
    main.plugins.fix-services.enabled = false # Disable the plugin
    ```
2. Edit the raspberry pi's config.txt file:
    ```bash
    sudo nano /boot/firmware/config.txt
    ```
3. Comment out `dtoverlay=disable-wifi` under `[pi0]` to disable the built-in WiFi:
    ```
    dtoverlay=disable-wifi
    ```
4. Save and exit the editor. Reboot the Raspberry Pi to apply the changes

## GPSD connection watchdog
This script monitors the Bluetooth connection between your pwnagotchi and your smartphone and the status of the GPSD service. If the connection drops, it attempts to reconnect automatically. This is useful for maintaining a stable internet connection via Bluetooth tethering.
1. Download the `gpsd_watchdog.sh` and `gpsd-watchdog.service` files:
    ```bash
    cd /usr/local/bin
    sudo wget https://raw.githubusercontent.com/michelemadonna/pwnagotchi/master/gpsd_watchdog.sh
    sudo chmod +x gpsd_watchdog.sh
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/michelemadonna/pwnagotchi/master/gpsd-watchdog.service
    ```
2. Edit the `gpsd_watchdog.sh` script to configure your smartphone's Bluetooth MAC address:
    ```bash
    sudo nano /usr/local/bin/gpsd_watchdog.sh
    ```
    - Replace `<PHONE_BT_MAC>` with your smartphone's Bluetooth MAC address.
    - Save and exit the editor.
3. Enable and start the `gpsd-watchdog` service:
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable gpsd-watchdog.service
    sudo systemctl start gpsd-watchdog.service
    ```
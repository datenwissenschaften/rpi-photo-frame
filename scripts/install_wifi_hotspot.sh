#!/bin/bash

# Update the system
echo "Updating the system..."
sudo apt update && sudo apt upgrade -y

# Install necessary packages
echo "Installing necessary packages: hostapd, dnsmasq, Flask..."
sudo apt install -y hostapd dnsmasq python3-flask

# Stop services to avoid conflicts during setup
echo "Stopping services for setup..."
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Configure dnsmasq for DHCP and DNS redirection to trigger captive portal
echo "Configuring dnsmasq..."
sudo tee /etc/dnsmasq.conf > /dev/null <<EOL
interface=wlan0      # Use wlan0 interface for the hotspot
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h

# Redirect all DNS queries to the Raspberry Pi (192.168.4.1) to trigger captive portal
address=/#/192.168.4.1
EOL

# Configure hostapd for the access point (no password, open network)
echo "Configuring hostapd (open hotspot)..."
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOL
interface=wlan0
driver=nl80211
ssid=Bilderrahmen  # The SSID of the hotspot
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOL

# Configure hostapd default file
sudo sed -i 's|#DAEMON_CONF=""|DAEMON_CONF="/etc/hostapd/hostapd.conf"|' /etc/default/hostapd

# Configure static IP for wlan0
echo "Configuring static IP for wlan0..."
sudo tee -a /etc/dhcpcd.conf > /dev/null <<EOL
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
EOL

# Restart dhcpcd service
sudo service dhcpcd restart

# Enable and restart dnsmasq and hostapd services
echo "Enabling and starting dnsmasq and hostapd..."
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl start hostapd
sudo systemctl start dnsmasq

# Set up Wi-Fi configuration web interface
echo "Setting up Flask web server for Wi-Fi configuration..."

# Create the Flask app directory
mkdir -p ~/wifi-config/templates

# Create the Flask app Python script
tee ~/wifi-config/app.py > /dev/null <<EOL
from flask import Flask, render_template, request
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/configure', methods=['POST'])
def configure():
    ssid = request.form['ssid']
    password = request.form['password']

    # Write the Wi-Fi credentials to wpa_supplicant.conf
    with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'a') as wifi_config:
        wifi_config.write(f'\\nnetwork={{\\n    ssid="{ssid}"\\n    psk="{password}"\\n}}\\n')

    # Restart the Wi-Fi interface to connect to the new network
    os.system('sudo systemctl restart dhcpcd')
    os.system('sudo systemctl restart wpa_supplicant')

    return 'Wi-Fi configured. Attempting to connect...'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOL

# Create the HTML template for Wi-Fi configuration form
tee ~/wifi-config/templates/index.html > /dev/null <<EOL
<!DOCTYPE html>
<html>
<head>
    <title>Wi-Fi Config</title>
</head>
<body>
    <h1>Configure Wi-Fi</h1>
    <form action="/configure" method="post">
        <label for="ssid">SSID:</label>
        <input type="text" id="ssid" name="ssid"><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password"><br>
        <input type="submit" value="Configure">
    </form>
</body>
</html>
EOL

# Create systemd service to run the Flask app on boot
echo "Creating systemd service to run Flask app on boot..."
sudo tee /etc/systemd/system/wifi-config.service > /dev/null <<EOL
[Unit]
Description=Wi-Fi Config Flask App
After=network.target

[Service]
ExecStart=/usr/bin/python3 /home/pi/wifi-config/app.py
WorkingDirectory=/home/pi/wifi-config
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the Flask app service
echo "Enabling and starting the Flask app service..."
sudo systemctl enable wifi-config
sudo systemctl start wifi-config

echo "Setup complete! The Raspberry Pi hotspot 'Bilderrahmen' is now active."
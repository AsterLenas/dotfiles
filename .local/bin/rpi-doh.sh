#!/usr/bin/env bash

INSTALLDIR="/opt/dnscrypt-proxy"
SERVICE="/etc/systemd/system/dnscrypt-proxy.service"
PATCH="$INSTALLDIR/changes.patch"
ARCHIVE="dnscrypt-proxy-linux_arm64-2.1.18.tar.gz"

echo "Downloading and installing dnscrypt-proxy:"
wget -P /opt https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.18/$ARCHIVE

tar -xf /opt/$ARCHIVE -C /opt

echo "Creating Patch file"
cat > "$PATCH" <<EOF
--- example-dnscrypt-proxy.toml 2026-07-18 14:02:22.000000000 +0200
+++ dnscrypt-proxy.toml 2026-08-15 12:33:39.616063545 +0200
@@ -28,6 +28,7 @@
 ## Remove the leading # first to enable this; lines starting with # are ignored.

 # server_names = ['scaleway-fr', 'google', 'yandex', 'cloudflare']
+ server_names = ['cloudflare']


 ## List of local addresses and ports to listen to. Can be IPv4 and/or IPv6.
@@ -37,7 +38,7 @@
 ## To listen to all IPv4 addresses, use \`listen_addresses = ['0.0.0.0:53']\`
 ## To listen to all IPv4+IPv6 addresses, use \`listen_addresses = ['[::]:53']\`

-listen_addresses = ['127.0.0.1:53']
+listen_addresses = ['127.0.0.1:5053']


 ## Maximum number of simultaneous client connections to accept
EOF

cd "$INSTALLDIR" && patch -p1 < "$PATCH"

echo "Creating systemd service:"
sudo tee "$SERVICE" > /dev/null <<EOF
[Unit]
Description=Encrypted/authenticated DNS proxy
ConditionFileIsExecutable=$INSTALLDIR/dnscrypt-proxy

[Service]
StartLimitInterval=5
StartLimitBurst=10
ExecStart=$INSTALLDIR/dnscrypt-proxy
WorkingDirectory=$INSTALLDIR
Restart=always
RestartSec=120
EnvironmentFile=-/etc/sysconfig/dnscrypt-proxy

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable dnscrypt-proxy
sudo systemctl start dnscrypt-proxy
sudo systemctl status dnscrypt-proxy

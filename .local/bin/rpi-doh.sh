#/usr/bin/env bash

# Upstream DNS
UPSTREAM="https://dns10.quad9.net/dns-query"

echo "Downloading and installing cloudflared:"
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
sudo mv -f ./cloudflared-linux-arm64 /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared

echo "Checking if cloudflared was succesfully installed"
cloudflared -v || exit 1

sudo useradd -s /usr/sbin/nologin -r -M cloudflared

echo "Creating file with default parameters:"
echo "# Commandline args for cloudflared, using Cloudflare DNS" | sudo tee /etc/default/cloudflared
echo "CLOUDFLARED_OPTS=--port 5053 --upstream $UPSTREAM" | sudo tee -a /etc/default/cloudflared
echo ""

sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared

echo "Creating systemd service:"
echo "[Unit]" | sudo tee /etc/systemd/system/cloudflared.service
echo "Description=cloudflared DNS over HTTPS proxy" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "After=syslog.target network-online.target" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "[Service]" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "Type=simple" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "User=cloudflared" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "EnvironmentFile=/etc/default/cloudflared" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "ExecStart=/usr/local/bin/cloudflared proxy-dns ""$""CLOUDFLARED_OPTS" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "Restart=on-failure" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "RestartSec=10" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "KillMode=process" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "[Install]" | sudo tee -a /etc/systemd/system/cloudflared.service
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/cloudflared.service

sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared

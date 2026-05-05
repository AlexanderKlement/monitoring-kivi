#!/bin/bash
set -e

NODE_EXPORTER_VERSION="1.11.1"

wget "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
tar -xvf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
sudo cp "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter" /usr/local/bin
sudo chown root:root /usr/local/bin/node_exporter
sudo chmod 755 /usr/local/bin/node_exporter

sudo useradd -M -r -s /bin/false node_exporter 2>/dev/null || true

sudo bash -c 'cat > /etc/systemd/system/node_exporter.service << EOL
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOL'

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter
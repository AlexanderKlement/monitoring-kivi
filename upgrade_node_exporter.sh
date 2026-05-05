#!/bin/bash
set -e

NODE_EXPORTER_VERSION="1.11.1"

echo "Stopping node_exporter..."
sudo systemctl stop node_exporter

echo "Downloading node_exporter v${NODE_EXPORTER_VERSION}..."
wget -q "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
tar -xf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

echo "Installing..."
sudo cp "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter" /usr/local/bin
sudo chown root:root /usr/local/bin/node_exporter
sudo chmod 755 /usr/local/bin/node_exporter

echo "Restarting node_exporter..."
sudo systemctl start node_exporter
sudo systemctl status node_exporter

echo "Cleaning up..."
rm -rf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64" "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"

echo "Done. node_exporter v${NODE_EXPORTER_VERSION} is running."
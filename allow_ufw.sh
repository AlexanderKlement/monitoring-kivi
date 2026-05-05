#!/bin/bash
set -e

# Allow access to node_exporter only from the monitoring server (srv3.kivi.bz.it)
sudo ufw allow from 202.61.206.116 to any port 9100
sudo ufw allow from 2a03:4000:5b:361::0 to any port 9100
sudo ufw deny 9100
#!/bin/bash

# Make things safer
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

cp -f scaler.sh /usr/local/bin
chmod +x /usr/local/bin/scaler.sh
cp cpufreq-userspace-scaler.service /lib/systemd/system
systemctl daemon-reload
systemctl start cpufreq-userspace-scaler.service
systemctl status cpufreq-userspace-scaler.service
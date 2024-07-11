#!/bin/bash
echo master = $2

# Install  curl
apt update
apt install curl -y

# kmsg fix
if [ ! -f /etc/systemd/system/conf-kmsg.service ]; then
    echo "#!/bin/sh -e" >> /usr/local/bin/conf-kmsg.sh
    echo "if [ ! -e /dev/kmsg ]; then" >> /usr/local/bin/conf-kmsg.sh
	echo "ln -s /dev/console /dev/kmsg" >> /usr/local/bin/conf-kmsg.sh
    echo "fi" >> /usr/local/bin/conf-kmsg.sh
    echo "mount --make-rshared /" >> /usr/local/bin/conf-kmsg.sh

    echo "[Unit]" >> /etc/systemd/system/conf-kmsg.service
    echo "Description=Make sure /dev/kmsg exists" >> /etc/systemd/system/conf-kmsg.service
    echo "[Service]" >> /etc/systemd/system/conf-kmsg.service
    echo "Type=simple" >> /etc/systemd/system/conf-kmsg.service
    echo "RemainAfterExit=yes" >> /etc/systemd/system/conf-kmsg.service
    echo "ExecStart=/usr/local/bin/conf-kmsg.sh" >> /etc/systemd/system/conf-kmsg.service
    echo "TimeoutStartSec=0" >> /etc/systemd/system/conf-kmsg.service
    echo "[Install]" >> /etc/systemd/system/conf-kmsg.service
    echo "WantedBy=default.target" >> /etc/systemd/system/conf-kmsg.service

    chmod +x /usr/local/bin/conf-kmsg.sh
    systemctl daemon-reload
    systemctl enable --now conf-kmsg
    systemctl start conf-kmsg
fi
if [ ! -f /usr/local/bin/k3s ]; then
    echo "Installing agent node.."
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" K3S_NODE_NAME="$(hostname)" K3S_TOKEN="$1" K3S_URL="https://$2:6443" sh -s -
fi
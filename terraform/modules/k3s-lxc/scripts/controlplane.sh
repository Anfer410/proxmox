#!/bin/bash
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
# k3s install
if [ ! -f /usr/local/bin/k3s ]; then
    echo "Installing k3s server node.."
    # curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" K3S_NODE_NAME="$1" K3S_TOKEN="$2" K3S_URL="https://$3:6443" sh -s - --disable traefik
    curl -fsL https://get.k3s.io | sh -s - --disable traefik --node-name "$(hostname)"

    # Deploy nginx ingress controller
    export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true
fi
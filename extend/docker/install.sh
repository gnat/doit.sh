#!/bin/bash
set -euo pipefail
# Reference: https://docs.docker.com/engine/security/rootless/

DOCKER_VERSION="20.10.22"; # Find latest version number: https://get.docker.com/rootless

echo "[$0] 📥 Installing Rootless Docker $DOCKER_VERSION"

# Do not run as root.
if [[ "$USER" == "root" ]]; then
	echo "[$0] ERROR 🔴 Do not run as root. This defeats the purpose of Rootless Docker."
	exit
fi

echo "[$0] 🟢 Trying to shutdown related services."
(docker ps -q | xargs docker stop) || true
(systemctl --user stop docker) || true

echo "[$0] 🟢 Trying to remove old versions of Rootless Docker."
cd ~/bin && rm -f *docker* *containerd* *runc* *rootlesskit* *vpnkit*

#read -p "[$0] ❓ Do you want to purge all containers, images, volumes? (y/n)" CHOICE
#if [[ $CHOICE == 'y' ]]; then
#	echo "[$0] 🟢 Purging all containers, images, volumes."
#	$(rootlesskit rm -rf ~/.local/share/docker) || true
#fi

mkdir -p /home/$USER/.config/systemd/user/docker.service.d
bash -c "cat <<-EOF > /home/$USER/.config/systemd/user/docker.service.d/override.conf
	[Service]
	Environment=DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER='slirp4netns'
EOF"

echo "[$0] 🟢 Installing Rootless Docker."
PATH=$PATH:/home/$USER/bin && tmp="$(mktemp -d)" && cd $tmp \
&& curl -L -o docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz" \
&& curl -L -o rootless.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-rootless-extras-$DOCKER_VERSION.tgz" \
&& mkdir -p /home/$USER/bin && cd /home/$USER/bin \
&& tar zxf "$tmp/docker.tgz" --strip-components=1 && tar zxf "$tmp/rootless.tgz" --strip-components=1 \
&& dockerd-rootless-setuptool.sh install

mkdir -p /home/$USER/.local/bin

echo "[$0] 🟢 Adding to bashrc."
if [[ $(cat /home/$USER/.bashrc | grep 'XDG_RUNTIME_DIR') = *XDG_RUNTIME_DIR* ]]; then
	sed -i '1iexport DOCKER_HOST=unix:///run/user/1000/docker.sock' ~/.bashrc
	sed -i '1iexport XDG_RUNTIME_DIR=/run/user/1000' ~/.bashrc
fi

echo "[$0] 🟢 Installing rootless docker-compose."
pip3 install docker-compose --upgrade

echo "[$0] 🟢 Enable on startup, and linger."
systemctl --user enable docker
sudo loginctl enable-linger $USER

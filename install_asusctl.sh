#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

#https://asus-linux.org/asusctl/
function requirements(){
	echo "---> Instalando Dependencias ... "
    apt-get install build-essential cmake libclang-dev libudev-dev libsystemd-dev libseat-dev libglib2.0-dev libgtk2.0-dev libgtk-3-dev nvidia-driver-535 nvidia-dkms-535 curl -y > /dev/null
    echo "---> Instalando Cargo ... "
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
	echo "---> Actualizando Sistema ... "
	update > /dev/null
}

#asusctl
function install_asusctl(){
    echo "---> Clonando Repositorios ... "
    git clone https://gitlab.com/asus-linux/asusctl.git > /dev/null
    cd asusctl
    make && sudo make install
    systemctl enable asusd.service --now
}

#supergfxctl
function install_supergfxctl(){
    echo "---> Clonando Repositorios ... "
    git clone https://gitlab.com/asus-linux/supergfxctl.git > /dev/null
    cd supergfxctl
    make && sudo make install
    systemctl enable supergfxd.service --now
}

#echo "Antes que Nada ... Lo escencial *_*"
#requirements
echo "Instalando asusctl for ASUS ROG..."
install_asusctl
echo "Instalando supergfxctl for ASUS ROG..."
install_supergfxctl
echo "Instalar extensión de gnome ..."
echo "https://extensions.gnome.org/extension/5344/supergfxctl-gex/"
echo "Enjoy 3:)"

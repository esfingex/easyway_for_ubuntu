#!/bin/bash
#Only Ubuntu

if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

function install_microcode(){
    version=$(dmidecode -s processor-manufacturer)
    echo "---> Instalando microcodes ${version} ... "
    if [ ${version:0:5} == 'Intel' ]; then
        apt-get install intel-microcode iucode-tool -y > /dev/null
    else 
        apt-get install amd64-microcode -y > /dev/null
    fi
}

function install_kvm_qemu(){

    echo "---> Instalando KVM & Qemu ... "
    apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

    echo "---> Agregando usuario actual a grupo libvirt..."
    usermod -aG libvirt $(whoami)

    echo "---> Habilitando y levantando libvirtd..."
    systemctl enable --now libvirtd
    newgrp libvirt

    echo "---> Cargando Modulo KVM ${version} ... "
    version=$(dmidecode -s processor-manufacturer)
    if [ ${version:0:5} == 'Intel' ]; then
        modprobe kvm_intel
        echo -e "kvm\nkvm_intel" | sudo tee /etc/modules-load.d/kvm.conf
    else 
        modprobe kvm_amd
        echo -e "kvm\nkvm_amd" | sudo tee /etc/modules-load.d/kvm.conf
    fi

}

echo "Instalando kvm & qemu ..."
install_microcode
install_kvm_qemu
echo "Recuerda Reiniciar el Sistema ..."
echo "Enjoy 3:)"
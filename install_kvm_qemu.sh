#!/bin/bash
#Only Ubuntu

if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
    echo "Actualizando el sistema..."
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

function install_virgl_support(){
  echo "---> Instalando soporte adicional VirGL y SPICE..."
  apt-get install -y \
    spice-client-glib-usb-acl-helper gir1.2-spiceclientgtk-3.0 \
    libspice-server1 libvirt-daemon-driver-video \
    libosinfo-bin spice-client-gtk virglrenderer \
    libepoxy0 libdrm-dev libegl1-mesa-dev \
    libgles2-mesa-dev libwayland-client0 libxkbcommon0 \
    libgbm1 libspice-client-glib-2.0-8 libvirglrenderer1 \
    libvirglrenderer-dev spice-vdagent \
    libgbm-dev libspice-protocol-dev libspice-server-dev \
    libspice-client-gtk-3.0-5 > /dev/null

    echo "---> Cargando Modulo Virtio Aceleracion 3D..."
    modprobe virtio_gpu

}


#Instalacion standar falta la que corra vulkan con las VM
function install_kvm_qemu(){
    echo "---> Instalando KVM & Qemu ... "
    apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients \
        bridge-utils virt-manager mesa-utils qemu-system-x86 \
        mesa-vulkan-drivers virt-viewer ovmf > /dev/null

    echo "---> Agregando usuario actual a grupo libvirt ..."
    usermod -aG libvirt $(whoami)

    echo "---> Agregando usuario libvirt al grupo de video..."
    usermod -aG render,video,kvm libvirt-qemu

    echo "---> Habilitando y levantando libvirtd..."
    systemctl enable --now libvirtd
    #newgrp libvirt

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

function check_wayland(){
    if echo "$XDG_SESSION_TYPE" | grep -qi wayland; then
        echo "Estás usando Wayland. Considera cambiar a X11 para mejor compatibilidad con VirGL."
    fi
}

echo "Instalando kvm & qemu ..."
check_wayland
install_microcode
install_kvm_qemu
install_virgl_support   #Beta
echo "Recuerda Reiniciar el Sistema ..."
echo "Enjoy 3:)"
#!/bin/bash
#https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html


function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

USER="${SUDO_USER:-${USER}}"
source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi


function install_docker(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	echo $text >> $source_list/docker.list
	echo "---> Docker Key ... "
	wget -qO- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmour -o $gpgkey_path/docker.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y > /dev/null
	echo "---> Permisos Usuario ... "
	groupadd docker
	usermod -aG docker $USER
	chmod 666 /var/run/docker.sock
	echo ""
}

function install_docker_desktop(){
	echo "---> Docker Desktop  ... "
	echo "---> Instalando Paquetes ... "
	apt-get install qemu-system-x86 pass uidmap -y > /dev/null
	echo "---> Descarga Docker Desktop ... "
	wget -q https://desktop.docker.com/linux/main/amd64/191736/docker-desktop-amd64.deb
	dpkg -i docker-desktop-amd64.deb
	echo "---> Eliminando Paquetes ... "
	rm docker-desktop-amd64.deb
	echo ""
}

function kvm_virtualization(){
    kvm_type=$(lsmod | grep kvm)
    echo "---> Instalando KVM virtualization support ${version} ... "
    if [ ${kvm_type:0:9} == 'kvm_intel' ]; then
        modprobe kvm_intel > /dev/null
    else 
        modprobe kvm_amd > /dev/null
    fi
	usermod -aG kvm $USER
}

function nvidia_container_toolkit(){
	echo "Instalando Nvidia Container Toolkit..."
	echo "---> Creando APT Source  ... "
	text="deb https://nvidia.github.io/libnvidia-container/$distribution/\$(ARCH) /"
	echo $text >> $source_list/nvidia-container-toolkit.list
	echo "---> Docker Key ... "
	wget -qO- https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmour -o $gpgkey_path/nvidia-container-toolkit-keyring.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install -y nvidia-container-toolkit nvidia-docker2 > /dev/null
	echo "---> Configuración NVIDIA Container Runtime ... "
	nvidia-ctk runtime configure --runtime=docker
	systemctl restart docker
	docker pull nvidia/cuda:12.1.0-base-ubuntu22.04
	echo "---> Ejecutando Test nvidia-smi ... "
	docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu22.04 nvidia-smi

}

install_docker
install_docker_desktop
kvm_virtualization
#nvidia_container_toolkit #Experimental
echo "Enjoy 3:)"
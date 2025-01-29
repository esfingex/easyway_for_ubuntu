#!/bin/bash
#Según doc
#https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu

#if [ "$EUID" -ne 0 ]; then
#    echo "Por favor, ejecute como root."
#    exit 1
#fi

#Only Ubuntu
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

version=$(. /etc/os-release; echo ${ID}${VERSION_ID//./})
source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype1=[arch=amd64]; fi
archtype2=x86_64

function nvidia_cuda(){
    echo "---> Creando APT Source ... "
	aptlist="$source_list/cuda-${version}-${archtype2}.list"

    if [ ! -f "$aptlist" ]; then
        echo "deb ${archtype1} https://developer.download.nvidia.com/compute/cuda/repos/${version}/${archtype2}/ /" | sudo tee "$aptlist" > /dev/null
    else
        echo "---> El repositorio ya está configurado."
    fi
        
    echo "---> Cuda Key ... "
    wget https://developer.download.nvidia.com/compute/cuda/repos/${version}/${archtype2}/cuda-keyring_1.1-1_all.deb
    if ! dpkg -i cuda-keyring_1.1-1_all.deb; then
        echo "Error al instalar la clave de CUDA."
        exit 1
    fi
    rm cuda-keyring_1.1-1_all.deb

    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A4B469963BF863CC
    apt-key export A4B469963BF863CC | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/nvidia-cuda-keyring.gpg
    rm /etc/apt/trusted.gpg

    update

}

function install_cuda(){
    echo "---> Instalando CUDA ... "
    apt-get -y install cuda nvidia-cuda-toolkit > /dev/null
}

function verify_installation(){
    echo "---> Verificando instalación ... "
    nvidia-smi
    nvcc --version
}

function update_12_to_12_8(){
    echo "---> Verificando instalación ... "
    rm -rf /usr/local/cuda
    ln -s /usr/local/cuda-12.8 /usr/local/cuda
    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

}

nvidia_cuda
install_cuda
verify_installation
#update_12_to_12_8

echo "Recuerda Reiniciar el Computador ..."
echo "Enjoy 3:)"






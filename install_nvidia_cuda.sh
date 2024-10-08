#!/bin/bash

#Según doc
#https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu

#Only Ubuntu
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

ubuntuv='ubuntu2204'
source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function nvidia_cuda(){
    echo "---> Creando APT Source  ... "
    text="deb https://developer.download.nvidia.com/compute/cuda/repos/${ubuntuv}/${archtype}/ /"
    echo $text >> $source_list/cuda-${ubuntuv}-${archtype}.list

    wget https://developer.download.nvidia.com/compute/cuda/repos/${ubuntuv}/${archtype}/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    rm cuda-keyring_1.1-1_all.deb

    #echo "---> Cuda Key ... "
    #wget -qO- https://developer.download.nvidia.com/compute/cuda/repos/${ubuntuv}/${archtype}/cuda-archive-keyring.gpg | gpg --dearmour > $gpgkey_path/cuda-archive-keyring.gpg
    #echo "---> Cuda Priority ... "
    #wget -qO- https://developer.download.nvidia.com/compute/cuda/repos/${ubuntuv}/${archtype}/cuda-${ubuntuv}.pin 
    #mv cuda-${ubuntuv}.pin /etc/apt/preferences.d/cuda-repository-pin-600
}

nvidia_cuda
echo "Enjoy 3:)"






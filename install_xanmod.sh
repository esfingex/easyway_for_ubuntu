#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

#update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_xanmod(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} http://deb.xanmod.org releases main"
	echo $text >> $source_list/xanmod-kernel.list
	echo "---> XanMod Key ... "
	wget -qO- https://dl.xanmod.org/gpg.key | gpg --dearmor > $gpgkey_path/xanmod-kernel.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install linux-xanmod-x64v3 -y > /dev/null
	echo ""
}

function install_microcode(){
    version=$(dmidecode -s processor-manufacturer)
    echo "---> Instalando microcodes ${version} ... "
    if [ ${version:0:5} == 'Intel' ]; then
        apt-get install intel-microcode iucode-tool -y > /dev/null
    else 
        apt-get install amd64-microcode -y > /dev/null
    fi
}

echo "Instalando XanMod ..."
install_xanmod
install_microcode
echo "Enjoy 3:)"
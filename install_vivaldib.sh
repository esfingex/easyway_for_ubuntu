#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecute como root."
    exit 1
fi

function update(){
	echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_vivaldi(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://repo.vivaldi.com/archive/deb/ stable main"
	echo $text >> $source_list/vivaldi.list
	echo "---> Vivaldi Key ... "
	wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor > $gpgkey_path/linux_signing_key.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install vivaldi-stable -y > /dev/null
	echo ""
}

echo "Instalando Vivaldi ..."
install_vivaldi
echo "Enjoy 3:)"
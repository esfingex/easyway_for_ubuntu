#!/bin/bash
function update(){
	apt-get update -y
	apt-get upgrade -y
	apt-get autoremove -y
}

release=$(lsb_release -cs)	#Versión de SO (solo ubuntu)
source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null

if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_vbox(){

	echo "---> Creando APT Source  ... "
    text="deb ${archtype} https://download.virtualbox.org/virtualbox/debian ${release} contrib"
    echo $text >> $source_list/vbox.list
	
	echo "---> VirtualBox Key ... "
    wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmour > $gpgkey_path/oracle-virtualbox-2016.gpg
	
	echo "---> Actualizando ... "
	update > /dev/null

	echo "---> Instalando Paquetes ... "
    apt install virtualbox-7.0  -y > /dev/null
	echo ""
}

echo "Instalando VirtualBox ..."
install_vbox
echo "Enjoy 3:)"

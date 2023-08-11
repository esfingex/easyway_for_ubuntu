#!/bin/bash
function update(){
	apt-get update -y
	apt-get upgrade -y
	apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_vscode(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://packages.microsoft.com/repos/code stable main"
	echo $text >> $source_list/vscode.list
	echo "---> VScode Key ... "
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmour > $gpgkey_path/microsoft.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install apt-transport-https code -y > /dev/null
	echo ""
}

echo "Instalando VScode ..."
install_vscode
echo "Enjoy 3:)"

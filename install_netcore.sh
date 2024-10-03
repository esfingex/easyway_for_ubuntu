#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d
distribution=$(. /etc/os-release;echo $ID/$VERSION_ID)

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_netcore(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://packages.microsoft.com/$distribution/prod jammy main"
	echo $text >> $source_list/microsoft-prod.list
	echo "---> VScode Key ... "
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmour > $gpgkey_path/microsoft.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install apt-transport-https dotnet-sdk-8.0 -y > /dev/null
	echo ""
}

echo "Instalando .Net Core ..."
install_netcore
echo "Enjoy 3:)"

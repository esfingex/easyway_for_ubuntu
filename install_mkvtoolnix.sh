#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_mkvtoolnix(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://mkvtoolnix.download/ubuntu/ jammy main"
	echo $text >>$source_list/mkvtoolnix.download.list
	echo "---> MKVToolNix Key ... "
	wget -qO- https://mkvtoolnix.download/gpg-pub-moritzbunkus.gpg | gpg --dearmor > $gpgkey_path/gpg-pub-moritzbunkus.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install apt-transport-https mkvtoolnix mkvtoolnix-gui -y > /dev/null
	echo ""
}

echo "Instalando MKVToolNix ..."
install_mkvtoolnix
echo "Enjoy 3:)"
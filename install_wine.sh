#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

release=$(lsb_release -cs)	#Versión de SO (solo ubuntu)
source_list=/etc/apt/sources.list.d

update > /dev/null
if [ "$(arch)" = "x86_64" ]; then archtype="arch=amd64"; fi

function install_winehq(){
	echo "---> Creando APT Source  ... "
	wget -NP $source_list/ https://dl.winehq.org/wine-builds/ubuntu/dists/$release/winehq-$release.sources
	echo "---> WineHQ Key ... "
	mkdir -pm755 /etc/apt/keyrings
	wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	dpkg --add-architecture i386
	apt install --install-recommends winehq-stable -y > /dev/null

	# Install Wine multiarch
	apt install wine64 wine32 winetricks -y
	echo ""
}

echo "Instalando WineHQ ..."
install_winehq
echo "Enjoy 3:)"

#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ "$(arch)" = "x86_64" ]; then archtype="arch=amd64"; fi

function install_tor(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://deb.torproject.org/torproject.org/ $(lsb_release -cs) main"
	echo $text >> $source_list/tor.list
	echo "---> Tor Key ... "
	wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmour -o $gpgkey_path/tor.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get installtor tor-geoipdb torsocks deb.torproject.org-keyring -y > /dev/null
}

echo "Instalando Tor ..."
install_tor
echo "Enjoy 3:)"
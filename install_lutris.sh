#!/bin/bash
function update(){
	apt-get update -y
	apt-get upgrade -y
	apt-get autoremove -y
}

latest=$(wget -q -O - https://api.github.com/repos/lutris/lutris/releases/latest | grep browser_download_url.*.deb)
filename=$(basename "$latest")
filename=${filename%?}

function install_lutris(){
	echo "---> Descargando Paquetes  ... "
	wget -q ${latest:31:-1}
	echo "---> Instalando Paquetes Adicionales ... "
	apt-get install fluid-soundfont-gm fluid-soundfont-gs python3-bs4 python3-html5lib python3-lxml python3-magic python3-setproctitle python3-soupsieve python3-webencodings -y > /dev/null
    echo "---> Install Lutris... "
	dpkg -i $filename > /dev/null
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Eliminando Paquetes ... "
	rm $filename
	echo ""
}

echo "Instalando Lutris ..."
install_lutris
echo "Enjoy 3:)"

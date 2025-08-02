#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

latest=$(wget -q -O - https://api.github.com/repos/lutris/lutris/releases/latest | jq -r '.assets[].browser_download_url')
filename=$(basename "$latest")

function install_lutris(){
	echo "---> Descargando Paquetes  ... "
	wget -q ${latest}
	echo "---> Instalando Paquetes Adicionales ... "
	apt-get install jq fluid-soundfont-gm fluid-soundfont-gs python3-bs4 python3-html5lib python3-lxml python3-magic python3-setproctitle python3-soupsieve python3-webencodings -y > /dev/null
    echo "---> Install Lutris... "
	dpkg -i ${filename} > /dev/null
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Eliminando Paquetes ... "
	rm ${filename}
	echo ""
}

echo "Instalando Lutris ..."
install_lutris
echo "Enjoy 3:)"

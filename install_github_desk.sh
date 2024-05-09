#!/bin/bash
#Only Ubuntu
function update(){
	apt-get update -y
	apt-get upgrade -y
	apt-get autoremove -y
}

#https://github.com/shiftkey/desktop/releases
latest=$(wget -q -O - https://api.github.com/repos/shiftkey/desktop/releases/latest | jq -r '.assets[].browser_download_url' | grep -e 'amd64.*.deb' | grep -v -e '.sha256')
filename=$(basename "$latest")

function install_gith_desk(){
	echo "---> Instalando Paquetes Adicionales... "
	apt-get install jq -y > /dev/null
	echo "---> Descargando Paquetes  ... "
	wget -q ${latest}
	echo "---> Instalando Paquetes  ... "
	dpkg -i ${filename} > /dev/null
	echo "---> Eliminando Paquetes ... "
	rm ${filename}
	echo ""
}

echo "Instalando Github Desktop ..."
install_gith_desk
echo "Enjoy 3:)"
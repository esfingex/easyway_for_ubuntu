#!/bin/bash
function update(){
	apt-get update -y
	apt-get upgrade -y
	apt-get autoremove -y
}

lasted=$(wget -q -O - https://api.github.com/repos/shiftkey/desktop/releases/latest | grep browser_download_url.*.deb)
filename=$(basename "$lasted")
filename=${filename%?}
update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_gith_desk(){
	echo "---> Descargando Paquetes  ... "
	wget -q ${lasted:31:-1}
	echo "---> Instalando Paquetes  ... "
	dpkg -i $filename > /dev/null
	echo "---> Eliminando Paquetes ... "
	rm $filename
	echo ""
}

echo "Instalando Github Desktop ..."
install_gith_desk
echo "Enjoy 3:)"
#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

function install_telegram(){
    echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Descargando Paquetes  ... "
	aria2c -x2 -q "https://telegram.org/dl/desktop/linux" -o telegram.tar.xz
    tar -xvf telegram.tar.xz
    mv Telegram /opt/
}

echo "Instalando Telegram ..."
install_telegram
echo "Enjoy 3:)"
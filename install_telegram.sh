#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecute como root."
    exit 1
fi

function update(){
    echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

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
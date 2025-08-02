#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, ejecute como root."
    exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

node_version=18 
source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_nodejs(){
    echo "---> Creando APT Source para NodeJs..."
    nodejs_list="$source_list/nodejs.list"
    nodejs_gpg="$gpgkey_path/nodejs.gpg"

    if [ ! -f "$nodejs_list" ]; then
        echo "deb ${archtype} https://deb.nodesource.com/node_$node_version.x nodistro main" | tee "$nodejs_list" > /dev/null
    else
        echo "---> El repositorio de NodeJs ya está configurado."
    fi

    if [ ! -f "$nodejs_gpg" ]; then
        echo "---> Descargando la clave GPG de NodeJs..."
        wget -qO- https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor | sudo tee "$nodejs_gpg" > /dev/null
    else
        echo "---> La clave GPG de NodeJs ya está configurada."
    fi

    echo "---> Actualizando el índice de paquetes..."
    update > /dev/null
    echo "---> Instalando NodeJs..."
    apt-get install apt-transport-https nodejs -y > /dev/null
    echo "---> NodeJs instalado con éxito."
}

echo "Instalando NodeJs ..."
install_nodejs
echo "Enjoy 3:)"

#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_vscode(){
    echo "---> Creando APT Source para VSCode..."
    aptlist="$source_list/vscode.list"
    aptgpg="$gpgkey_path/microsoft.gpg"

    if [ ! -f "$aptlist" ]; then
        echo "deb ${archtype} https://packages.microsoft.com/repos/code stable main" | sudo tee "$aptlist" > /dev/null
    else
        echo "---> El repositorio ya está configurado."
    fi

    if [ ! -f "$aptgpg" ]; then
        echo "---> Descargando la clave GPG de Microsoft..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmour | sudo tee "$aptgpg" > /dev/null
    else
        echo "---> La clave GPG ya está configurada."
    fi

    echo "---> Actualizando el índice de paquetes..."
    update > /dev/null
    echo "---> Instalando VSCode..."
    apt-get install apt-transport-https code -y > /dev/null
    echo "---> VSCode instalado con éxito."
}

echo "Instalando VScode ..."
install_vscode
echo "Enjoy 3:)"

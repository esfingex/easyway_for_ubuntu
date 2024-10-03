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
    vscode_list="$source_list/vscode.list"
    vscode_gpg="$gpgkey_path/microsoft.gpg"

    if [ ! -f "$vscode_list" ]; then
        echo "deb ${archtype} https://packages.microsoft.com/repos/code stable main" | sudo tee "$vscode_list" > /dev/null
    else
        echo "---> El repositorio de VSCode ya está configurado."
    fi

    if [ ! -f "$vscode_gpg" ]; then
        echo "---> Descargando la clave GPG de Microsoft..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmour | sudo tee "$vscode_gpg" > /dev/null
    else
        echo "---> La clave GPG de Microsoft ya está configurada."
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

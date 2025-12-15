#!/bin/bash
#if [ "$EUID" -ne 0 ]; then
#    echo "Por favor, ejecute como root."
#    exit 1
#fi

function update(){
    echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_antigravity(){
    echo "---> Creando APT Source para Antigravity..."
    aptlist="$source_list/antigravity.list"
    aptgpg="$gpgkey_path/antigravity.gpg"

    if [ ! -f "$aptlist" ]; then
        echo "deb ${archtype} https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee "$aptlist" > /dev/null
    else
        echo "---> El repositorio ya está configurado."
    fi

    if [ ! -f "$aptgpg" ]; then
        echo "---> Descargando la clave GPG de Google Antigravity..."
        wget -qO- https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | gpg --dearmor | sudo tee "$aptgpg" > /dev/null
    else
        echo "---> La clave GPG ya está configurada."
    fi

    echo "---> Actualizando el índice de paquetes..."
    update > /dev/null
    echo "---> Instalando G. Antigravity..."
    apt-get install antigravity -y > /dev/null
    echo "---> Antigravity instalado con éxito."
}

echo "Instalando Antigravity ..."
install_antigravity
echo "Enjoy 3:)"


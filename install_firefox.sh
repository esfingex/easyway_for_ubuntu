#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_firefox(){
    echo "---> Creando APT Source para Firefox..."
    firefox_list="$source_list/firefox.list"
    firefox_gpg="$gpgkey_path/firefox.gpg"

    if [ ! -f "$firefox_list" ]; then
        echo "deb ${archtype} https://packages.mozilla.org/apt mozilla main" | tee "$firefox_list" > /dev/null
    else
        echo "---> El repositorio de Firefox ya está configurado."
    fi

    if [ ! -f "$firefox_gpg" ]; then
        echo "---> Descargando la clave GPG de Firefox..."
        wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg | gpg --dearmor | tee "$firefox_gpg" > /dev/null
    else
        echo "---> La clave GPG de Firefox ya está configurada."
    fi

    echo "
    Package: *
    Pin: origin packages.mozilla.org 
    Pin-Priority: 1000 " | tee /etc/apt/preferences.d/mozilla

    echo "---> Actualizando el índice de paquetes..."
    update > /dev/null
    echo "---> Instalando Firefox..."
    apt-get install firefox -y > /dev/null
    echo "---> Firefox instalado con éxito."
}

echo "Instalando Firefox ..."
install_firefox
echo "Enjoy 3:)"

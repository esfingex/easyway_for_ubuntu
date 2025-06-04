#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d
version=$(. /etc/os-release;echo $ID/$VERSION_ID)
distribution=$(. /etc/os-release;echo $VERSION_CODENAME)

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_netcore(){
	echo "---> Creando APT Source para NetCore... "
	aptlist="$source_list/microsoft-prod.list"
    aptgpg="$gpgkey_path/microsoft.gpg"

	if [ ! -f "$aptlist" ]; then
        echo "deb ${archtype} https://packages.microsoft.com/$version/prod $distribution main" | sudo tee "$aptlist" > /dev/null
    else
        echo "---> El repositorio ya está configurado."
    fi

    if [ ! -f "$aptgpg" ]; then
        echo "---> Descargando la clave GPG de Microsoft..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee "$aptgpg" > /dev/null
    else
        echo "---> La clave GPG ya está configurada."
    fi

	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install apt-transport-https dotnet-sdk-8.0 -y > /dev/null
	echo ""

}

echo "Instalando .Net Core ..."
install_netcore

echo "Enjoy 3:)"

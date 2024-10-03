#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

function install_flatpak(){
    echo "---> Instalando Repositorio  ... "
	add-apt-repository ppa:flatpak/stable -y > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install flatpak gnome-software-plugin-flatpak -y > /dev/null
    echo "---> Instalando Repositorio de Flatpak... "
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo "---> Actualizando ... "
	update > /dev/null
	echo ""
}

echo "Instalando Flatpak ..."
install_flatpak
echo "Enjoy 3:)"
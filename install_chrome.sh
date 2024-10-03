#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

function install_chrome(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} http://dl.google.com/linux/chrome/deb/ stable main"
	echo $text >>$source_list/google-chrome.list
	echo "---> Chrome Key ... "
	wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmour > $gpgkey_path/linux_signing_key.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install google-chrome-stable -y > /dev/null
	echo ""
}

echo "Instalando Chrome ..."
install_chrome
echo "Enjoy 3:)"
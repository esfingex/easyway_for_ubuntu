#!/bin/bash
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

WPS=wps-office.deb

function wps_office(){
	echo "---> Descargando Paquetes  ... "
	wget -qO $WPS https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11664/wps-office_11.1.0.11664.XA_amd64.deb
	dpkg -i $WPS > /dev/null
	
	echo "Installing Fonts..."
	#Microsoft Fonts
	DEBIAN_FRONTEND=noninteractive apt-get install -qq ttf-mscorefonts-installer > /dev/null
	fc-cache -f -v > /dev/null
    
    #Propias de WPS
	git clone https://github.com/iamdh4/ttf-wps-fonts.git > /dev/null
	mv ttf-wps-fonts/* /usr/share/fonts/wps-office/

	sudo rm /usr/share/fonts/wps-office/install.sh
	sudo rm /usr/share/fonts/wps-office/README.md
	sudo rm -R /usr/share/fonts/wps-office/.git

	echo "Eliminando Fuentes"
	rm -R ttf-wps-fonts/
	rm $WPS

	update > /dev/null
}

echo "Instalando WPS Office ..."
wps_office
echo "Enjoy 3:)"
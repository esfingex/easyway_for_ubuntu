#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
	echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

source_list=/etc/apt/sources.list.d
gpgkey_path=/etc/apt/trusted.gpg.d

update > /dev/null
if [ $(arch) == 'x86_64' ]; then archtype=[arch=amd64]; fi

apt-get install gnupg -y > /dev/null

function install_mongo(){
	echo "---> Creando APT Source  ... "
	text="deb ${archtype} https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse"
	echo $text >> $source_list/mongodb.list
	echo "---> MongoDB Key ... "
	wget -qO- https://www.mongodb.org/static/pgp/server-5.0.asc | gpg --dearmor -o $gpgkey_path/mongodb.gpg
	echo "---> Actualizando ... "
	update > /dev/null
	echo "---> Instalando Paquetes ... "
	apt-get install mongodb-org -y > /dev/null
	echo "---> Levantando Servicios"
	systemctl start mongod.service 
}

function security_mongo(){
	echo "---> Configurando Firewall  ... "
	ufw allow 27017/tcp

}

function mongo_gui(){
	echo "---> Instalando Paquetes  ... "
	apt-get install  gconf-service gconf-service-backend gconf2-common libgconf-2-4 -y > /dev/null
	echo "---> Descargando Instalador ... "
	wget -q https://downloads.mongodb.com/compass/mongodb-compass_1.32.6_amd64.deb
	echo "---> Instalando Mongo Compass  ... "
	dpkg -i mongodb-compass_1.32.6_amd64.deb > /dev/null
}

echo "Instalando MongoDB ..."
install_mongo
security_mongo
mongo_gui
echo "Enjoy 3:)"

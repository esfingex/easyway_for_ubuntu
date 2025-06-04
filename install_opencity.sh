#!/bin/bash

# Script de instalación de OpenZiti para Ubuntu 24.04
# Descarga la última versión, la instala y configura el entorno básico.
#No siempre esta actualizado el repositorio con el releases lastest
#Recuerda revisar manual si es necesario

# Variables
INSTALL_DIR="/opt/openziti"
BIN_DIR="/usr/local/bin"
ZITI_VERSION=$(curl -s https://api.github.com/repos/openziti/ziti/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | cut -c 2-)
NAME_INSTALL=athena

# Verificar si el script se ejecuta como root
#if [ "$EUID" -ne 0 ]; then
#  echo "Por favor, ejecuta este script como root o con sudo."
#  exit 1
#fi

#Only Ubuntu
function update(){
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

function install_base(){
  echo "Actualizando el sistema e Instalando Paquetes base..."
  sudo apt install -y curl unzip git golang make openssl yamllint

  # Descargar la última versión de OpenZiti
  echo "Descargando OpenZiti versión $ZITI_VERSION..."
  wget https://github.com/openziti/ziti/releases/download/v$ZITI_VERSION/ziti-linux-amd64-$ZITI_VERSION.tar.gz -O ziti.tar.gz
  echo "Extrayendo binarios..."
  tar -xvzf ziti.tar.gz

  # Mover los binarios a /usr/local/bin
  echo "Instalando binarios en $BIN_DIR..."
  mv ziti $BIN_DIR/

  # Verificar la instalación
  echo "Verificando la instalación..."
  ziti version

}

function install_conf(){
  echo "Creando directorio de instalación en $INSTALL_DIR..."
  mkdir -p $INSTALL_DIR
  echo "Creando estructura de directorios para configuración..."
  mkdir -p $INSTALL_DIR/{controller,router}

  echo "Creando archivo de configuración del controlador..."
  
tee $INSTALL_DIR/controller/ctrl.yaml <<EOF
v: 3
db: sqlite
identity:
  cert: $INSTALL_DIR/controller/cert.pem
  key:  $INSTALL_DIR/controller/key.pem
edge:
  api:
    advertise: "0.0.0.0:1280"
EOF

}

function install_cert(){
  echo "Generando certificados para el controlador..."
  openssl req -x509 -newkey rsa:4096 -keyout $INSTALL_DIR/controller/key.pem -out $INSTALL_DIR/controller/cert.pem -days 365 -nodes -subj "/CN=openziti-controller"
  openssl req -x509 -newkey rsa:4096 -keyout $INSTALL_DIR/controller/ca.key.pem -out $INSTALL_DIR/controller/ca.cert.pem -days 365 -nodes -subj "/CN=openziti-ca"
  chmod -R 644 /opt/openziti/controller/certs/*
  chown -R $(whoami):$(whoami)  $INSTALL_DIR/controller/


}


#update
#install_base
#install_conf
install_cert

# Mensaje final
echo "¡Instalación completada!"
echo "Puedes iniciar el controlador con el siguiente comando:"
echo "ziti controller run $INSTALL_DIR/controller/ctrl.yaml"
echo "Enjoy 3:)"







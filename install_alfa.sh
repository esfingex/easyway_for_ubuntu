#!/bin/bash
#Install Drivers ALFA AWUSO36AXML

if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

function update(){
    echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

function install_firmware(){

    wget -O MT7921AU_Linux.tar https://files.alfa.com.tw/%5B1%5D%20WiFi%20USB%20adapter/AWUS036AXML/Linux/MT7921AU%EF%BC%88Linux%EF%BC%89.tar

    echo "📦 Extrayendo firmware..."
    tar -xvf MT7921AU_Linux.tar

    echo "📂 Copiando archivos a /lib/firmware/mediatek/"
    cp WIFI_RAM_CODE_MT7961_1.bin /lib/firmware/mediatek/
    cp WIFI_MT7961_patch_mcu_1_2_hdr.bin /lib/firmware/mediatek/

    chmod 644 /lib/firmware/mediatek/WIFI_RAM_CODE_MT7961_1.bin
    chmod 644 /lib/firmware/mediatek/WIFI_MT7961_patch_mcu_1_2_hdr.bin

    echo "✅ Firmware instalado."
}

install_firmware
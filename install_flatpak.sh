#!/bin/bash
function update(){
	echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

if [ "$EUID" -ne 0 ]; then
  echo "Por favor ejecuta como root"
  exit 1
fi

update > /dev/null

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

#Beta Install Nvidia with Bottle (Inyect Files)
#Se debe instalar las librerías de Nvidia para este caso
#hay 2 forma de instalar estas librerías
#1.- de add-apt-repository ppa:graphics-drivers/ppa
#2.- repositorio oficial de Nvidia
#Es mejor el repo oficial
function install_flatpak_nvidia(){
	DEST_DIR="/opt/flatpak-nvidia-libs"

	echo "[+] Creando directorio de Instalación ..."
	mkdir -p $DEST_DIR

	echo "[+] Copiando Librerías Nvidia..."
	cp /usr/lib/x86_64-linux-gnu/libGLX.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libGLdispatch.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-glcore.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-tls.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-glsi.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-gpucomp.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libGL.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libGLX_nvidia.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-glvkspirv.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-opticalflow.so* $DEST_DIR
	cp /usr/lib/x86_64-linux-gnu/libnvidia-rtcore.so* $DEST_DIR
	
	cp /usr/lib/x86_64-linux-gnu/libnvidia-ngx.so* $DEST_DIR
	ln -s libnvidia-ngx.so.570.158.01 libnvidia-ngx.so
	ln -s libnvidia-ngx.so.570.158.01 libnvidia-ngx.so1

	cp /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.570.158.01 
	ln -s libnvidia-ml.so.570.158.01 libnvidia-ml.so
	ln -s libnvidia-ml.so.570.158.01 libnvidia-ml.so1

	cp /usr/lib/x86_64-linux-gnu/libnvidia-cfg.so.570.158.01
	ln -s libnvidia-cfg.so.570.158.01 libnvidia-cfg.so
	ln -s libnvidia-cfg.so.570.158.01 libnvidia-cfg.so1
	
	cp /usr/lib/x86_64-linux-gnu/libnvidia-encode.so.570.158.01
	ln -s libnvidia-encode.so.570.158.01 libnvidia-encode.so
	ln -s libnvidia-encode.so.570.158.01 libnvidia-encode.so1



	# Crear archivo JSON de vendor para GLVND
	echo "[+] Configura librería..."
	tee $DEST_DIR/50_nvidia.json >/dev/null <<EOF
	{
		"file_format_version": "1.0.0",
		"ICD": {
			"library_path": "libGLX_nvidia.so.0"
		}
	}
EOF

	#Soporte Vulkan
	echo "[+] Copiando Librerías Vulkan..."
	cp /usr/lib/x86_64-linux-gnu/libvulkan.so.1 $DEST_DIR
	cp /usr/share/vulkan/icd.d/nvidia_icd.json $DEST_DIR
	cp /usr/share/vulkan/implicit_layer.d/nvidia_layers.json $DEST_DIR

	echo "[+] Ajustando rutas internas en los JSON..."
	sed -i 's#"library_path": "libvulkan.so.1"#"library_path": "/opt/flatpak-nvidia-libs/libvulkan.so.1"#' $DEST_DIR/nvidia_icd.json
	sed -i 's#"library_path": "libvulkan.so.1"#"library_path": "/opt/flatpak-nvidia-libs/libvulkan.so.1"#' $DEST_DIR/nvidia_layers.json



	#Dar permisos adecuados
	chmod 644 $DEST_DIR/50_nvidia.json
	chmod 644 $DEST_DIR/nvidia_icd.json
	chmod 644 $DEST_DIR/nvidia_layers.json
	chmod -R 755 $DEST_DIR


	#Aplicar override en Flatpak
	#flatpak override --user --show com.usebottles.bottles			Para Pruebas
	flatpak override --user com.usebottles.bottles \
	--env=__EGL_VENDOR_LIBRARY_FILENAMES=/opt/flatpak-nvidia-libs/50_nvidia.json \
	--env=VK_ICD_FILENAMES=/opt/flatpak-nvidia-libs/nvidia_icd.json \
	--env=VK_LAYER_PATH=/opt/flatpak-nvidia-libs \
	--env=VK_LAYER_ENABLE=VK_LAYER_NVIDIA_overlay \
	--env=LD_LIBRARY_PATH=/opt/flatpak-nvidia-libs:/app/lib \
	--env=__NV_DLSS_LIBRARY_PATH=/opt/flatpak-nvidia-libs/libnvidia-ngx.so.1
	#--env=__NV_PRIME_RENDER_OFFLOAD=1 \		#Solo si tienes laptop
	--env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
	--filesystem=/opt/flatpak-nvidia-libs:ro

}

echo "Instalando Flatpak ..."
install_flatpak
#echo "Configurando Nvidia with Flatpak ..."
#install_flatpak_nvidia
echo "Enjoy 3:)"
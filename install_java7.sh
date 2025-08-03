#!/bin/bash
#Only Ubuntu
function update(){
    echo "Actualizando el sistema..."
	apt-get update -y && apt-get upgrade -y && apt-get autoremove -y
}

update > /dev/null

function install_maven(){
    apt install maven -y > /dev/null
}

function install_java7(){
    #Java7
    mkdir -p /usr/lib/jvm
    tar -xzf src/jdk-7u80-linux-x64.tar.gz
    mv jdk1.7.0_80/ /usr/lib/jvm/

    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.7.0_80/bin/java" 1001
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.7.0_80/bin/javac" 1001
}

function install_java8(){
    #OpenJDK 8.0 o superiores
    add-apt-repository ppa:openjdk-r/ppa -y > /dev/null
    apt-get install openjdk-8-jdk -y
}

function install_tomcat(){
    echo "---> Instalando TomCat 5.5.17  ... "
    tar -xf src/apache-tomcat-5.5.17.tar.xz
    mv apache-tomcat-5.5.17/ /opt/tomcat5
}

function install_netbeans(){
	echo "---> Descargando Instalador ... "
	#wget -q https://github.com/Friends-of-Apache-NetBeans/netbeans-installers/releases/download/v26-build1/apache-netbeans_26-1_amd64.deb
    echo "---> Instalando NetBeans  ... "
	dpkg -i src/apache-netbeans_26-1_amd64.deb > /dev/null
}

#echo "Elige Versión de Java  ... "
#update-alternatives --config java

echo "Instalando Maven"
install_maven
echo "Instalando Java 1.7 ..."
install_java7
echo "Instalando Java 1.8 ..."
install_java8
echo "Instalando TomCat 5.5.17 ..."
install_tomcat
echo "Instalando NetBeans ..."
install_netbeans

echo "Permisos"
sudo chmod -R 755 /usr/lib/jvm/jdk1.7.0_80 /opt/tomcat5


echo "Enjoy 3:)"
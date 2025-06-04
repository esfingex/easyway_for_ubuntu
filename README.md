# easyway_for_linux
Script in Bash for Automation in Ubuntu

## Usage
```
sudo chmod +x <script_name.sh>
sudo ./<script_name.sh>
```

```bash
1.- Vivaldi Browser
2.- Github Desktop
3.- VScode
4.- Dockers With Cuda Core
5.- Red TOR
6.- Spark
7.- MongoDB
8.- Chrome
9.- WPS Office
10.- Lutris
11.- XanMod
12.- WineHQ
13.- Virtual Box
14.- Asusctl (ASUS ROG)
15.- Telegram
16.- Flatpak
17.- MkvToolnix
18.- NetCore
```

**Descripción general**

Este repositorio contiene principalmente scripts de shell para automatizar la instalación de aplicaciones en Ubuntu. El archivo README explica cómo ejecutarlos con permisos de administrador y enumera las instalaciones disponibles. Cada script es autocontenido y suele seguir un patrón común: define una función `update` para ejecutar `apt-get update` y `upgrade`, configura archivos en `/etc/apt/sources.list.d` y claves en `/etc/apt/trusted.gpg.d`, y finalmente instala los paquetes necesarios.

Ejemplo del README con las instrucciones básicas y la lista de scripts disponibles

Un script típico, como `install_node.sh`, incluye las funciones para crear el repositorio, añadir la clave GPG y proceder con la instalación de Node.js

Además hay un archivo `.vscode/launch.json` que define una configuración simple para depurar scripts Bash desde VS Code

**Estructura**

- `README.md`: instrucciones generales y lista de scripts.
- `.vscode/launch.json`: configuración de depuración para Bash.
- `install_*.sh`: más de 15 scripts que instalan navegadores, editores, herramientas de desarrollo, Wine, Docker, etc. Cada uno ejecuta pasos similares para añadir repositorios, actualizar e instalar.
- `DAC Topping DX3 Pro+ en Linux.md`: guía extensa (en español) para configurar correctamente ese DAC bajo Linux.

**Aspectos importantes**

1. **Permisos de superusuario**  
   Todos los scripts deben ejecutarse con `sudo`, pues modifican repositorios del sistema y realizan instalaciones con `apt-get`.
2. **Manejo de repositorios y claves GPG**  
   Cada script agrega su propio `.list` bajo `/etc/apt/sources.list.d/` y guarda la clave en `/etc/apt/trusted.gpg.d/`. Conviene revisar esas ubicaciones si se desea personalizar o limpiar repositorios.
3. **Actualización previa**  
   La función `update` (presente en casi todos los scripts) ejecuta actualización, mejora y eliminación de paquetes en un solo paso.
4. **Scripts independientes**  
   No existe un orquestador único. Deben ejecutarse manualmente según la aplicación que se quiera instalar.
5. **Código modesto y sin pruebas**  
   Es un proyecto simple de automatización. No incluye tests ni integración continua.


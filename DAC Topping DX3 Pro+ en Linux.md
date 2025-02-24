# **Guía Completa para Configurar el DAC Topping DX3 Pro+ en Linux con Bit Perfect**

Esta guía te ayudará a configurar el **Topping DX3 Pro+** en **Ubuntu 24.04** para asegurar que el audio sea transmitido **sin alteraciones ni resampling (modo Bit Perfect)**. "Bit Perfect" significa que el audio se reproduce en su frecuencia y profundidad de bits originales sin modificaciones, asegurando la máxima fidelidad posible al archivo fuente.

## **1️⃣ Verificar el DAC en ALSA**

Antes de configurar el sistema, primero debemos identificar en qué tarjeta ALSA reconoce el DX3 Pro+.

Ejecuta en la terminal:

```bash
aplay -l
```

Salida esperada:

```
**** Lista de PLAYBACK dispositivos hardware ****
tarjeta 3: Pro [DX3 Pro+], dispositivo 0: USB Audio [USB Audio]
```

📌 **Nota:** Recuerda el número de tarjeta y dispositivo. En este caso, el DX3 Pro+ es **`hw:3,0`**.

---

## **2️⃣ Configurar PipeWire para Evitar Resampling**

Ubuntu 24.04 usa **PipeWire** en lugar de PulseAudio, lo que puede forzar el audio a **48 kHz**. Esto se debe a que muchas configuraciones de audio en Linux utilizan 48 kHz como estándar para evitar conversiones en ciertos dispositivos de hardware y mejorar la compatibilidad con formatos de audio de video. Para evitarlo:

### **Editar la configuración de PipeWire**

Ejecuta en la terminal:

```bash
mkdir -p ~/.config/pipewire/pipewire.conf.d/
nano ~/.config/pipewire/pipewire.conf.d/99-custom.conf
```

Agrega lo siguiente:

```ini
context.properties = {
    default.clock.rate = 44100
    default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ]
    resample.quality = 0
}
```

📌 **Explicación:**

- **default.clock.rate = 44100** → Usa **44.1 kHz** por defecto (evita que se fuerce a 48 kHz).
- **default.clock.allowed-rates** → Permite que PipeWire cambie la frecuencia según el archivo.
- **resample.quality = 0** → **Desactiva el resampling forzado**.

**Guardar y salir**: `CTRL+X`, `Y`, `Enter`.

### **Reiniciar PipeWire**

```bash
systemctl --user restart pipewire pipewire-pulse
```

---

## **3️⃣ Configurar VLC para Usar ALSA Directo**

Para evitar que VLC haga resampling:

1️⃣ **Abre VLC** y ve a **Herramientas > Preferencias (****`Ctrl + P`****)**.
2️⃣ En la parte inferior, selecciona **"Mostrar configuración: Todo"**.
3️⃣ Ve a **Audio > Módulos de salida > ALSA**.
4️⃣ En **"Dispositivo de salida de audio"**, escribe manualmente:

```
hw:3,0
```

*(Cambia "3" por el número correcto de tu tarjeta si es diferente).*\
5️⃣ Ve a **"Muestreo de Audio"** y **desactiva "Forzar frecuencia de muestreo"**.
6️⃣ **Guarda los cambios y cierra VLC**.

🔹 **Ejecutar VLC desde la terminal con ALSA directo**:

```bash
PULSE_LATENCY_MSEC=60 ALSA_PCM_CARD=3 vlc
```

*(Cambia "3" por el número correcto de tu tarjeta si es diferente.)*

---

## **4️⃣ Verificar que el DAC Recibe el Audio Correctamente**

Para asegurarte de que el DX3 Pro+ recibe la frecuencia original de cada archivo, reproduce un archivo y ejecuta:

```bash
cat /proc/asound/card3/pcm0p/sub0/hw_params
```

📌 **Resultados esperados:**

- Si reproduces un **MP3 de 44.1 kHz**:
  ```
  rate: 44100 (44100/1)
  ```
- Si reproduces un **FLAC de 96 kHz**:
  ```
  rate: 96000 (96000/1)
  ```
- Si reproduces un **FLAC de 192 kHz**:
  ```
  rate: 192000 (192000/1)
  ```

✅ **Si ****`rate`**** cambia según el archivo reproducido, significa que tienes Bit Perfect funcionando al 100%.** 🎧🔥

### **Cómo interpretar los valores de ****`hw_params`**

La salida del comando `hw_params` contiene varias líneas de información. Aquí están las más relevantes:

- **rate:** Indica la frecuencia de muestreo en Hz. Debe coincidir con la frecuencia del archivo reproducido.
- **format:** Muestra la profundidad de bits en la que ALSA está enviando el audio al DAC. Valores comunes incluyen `S16_LE` (16 bits) y `S32_LE` (32 bits).
- **channels:** Indica el número de canales de audio (2 para estéreo).
- **buffer\_size y period\_size:** Controlan el tamaño del búfer de audio, pero no afectan la calidad del sonido.

Si `rate` no cambia al reproducir diferentes archivos, significa que aún hay resampling activo y se debe revisar la configuración de PipeWire y VLC.
Para asegurarte de que el DX3 Pro+ recibe la frecuencia original de cada archivo, reproduce un archivo y ejecuta:

```bash
cat /proc/asound/card3/pcm0p/sub0/hw_params
```

📌 **Resultados esperados:**

- Si reproduces un **MP3 de 44.1 kHz**:
  ```
  rate: 44100 (44100/1)
  ```
- Si reproduces un **FLAC de 96 kHz**:
  ```
  rate: 96000 (96000/1)
  ```
- Si reproduces un **FLAC de 192 kHz**:
  ```
  rate: 192000 (192000/1)
  ```

✅ **Si ****`rate`**** cambia según el archivo reproducido, significa que tienes Bit Perfect funcionando al 100%.** 🎧🔥

---

## **🚀 Conclusión**

🎯 **Ahora Ubuntu 24.04 está enviando el audio original sin resampling forzado al DX3 Pro+.**
🎯 **VLC está configurado para usar ALSA directo y respetar la frecuencia original.**
🎯 **Puedes verificarlo con ****`hw_params`****, que te dirá exactamente la frecuencia que recibe el DAC.**

🚀 **¡Disfruta de tu audio en la mejor calidad posible con el DX3 Pro+ en Linux!** 🎶🔥

---

